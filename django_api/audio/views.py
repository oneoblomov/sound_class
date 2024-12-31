from rest_framework import status, viewsets
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import AudioFile, Person
from .serializers import AudioFileSerializer, PersonSerializer
from django.core.files.storage import default_storage

from pydub import AudioSegment
from pydub.effects import normalize, low_pass_filter, high_pass_filter
from pyannote.audio import Pipeline
from textblob import TextBlob

import wave
import json

from vosk import Model, KaldiRecognizer
import librosa
import soundfile as sf

import torch
import torchaudio
import cudf as pd
import numpy as np
torch.backends.cuda.matmul.allow_tf32 = True
torch.backends.cudnn.allow_tf32 = True

pipeline = Pipeline.from_pretrained("pyannote/speaker-diarization-3.1", use_auth_token="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").to(torch.device("cuda"))
model_path = "/home/kaplan/Downloads/vosk-model-small-en-us-0.15"
model = Model(model_path)

from sklearn.feature_extraction.text import TfidfVectorizer

def konu_tespiti_tfidf(metin, en_fazla=3):
    tfidf = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf.fit_transform([metin])
    skorlar = zip(tfidf.get_feature_names_out(), tfidf_matrix.toarray()[0])
    en_fazla_gecen = sorted(skorlar, key=lambda x: x[1], reverse=True)[:en_fazla]
    
    return [kelime for kelime, _ in en_fazla_gecen]

def duygu_analizi_yap(metin):
    if not metin:
        return None
    
    blob = TextBlob(metin)
    polarite = blob.sentiment.polarity
    
    if (polarite > 0):
        return 1
    elif (polarite < 0):
        return -1
    else:
        return 0
    
def frekans(file):
    y, sr = librosa.load(file, sr=None)
    
    new_sr = 16000
    y_resampled = librosa.resample(y, orig_sr=sr, target_sr=new_sr)
    resampled_file = "resampled.wav"
    sf.write(resampled_file, y_resampled, new_sr)

    audio = AudioSegment.from_wav(resampled_file)
    normalized_audio = normalize(audio)
    filtered_audio = low_pass_filter(normalized_audio, 3000)
    filtered_audio = high_pass_filter(filtered_audio, 300)
    
    filtered_audio.export(file, format="wav")
    
    return sound(file)

def sound(file):
    waveform, sample_rate = torchaudio.load(file)  
    diarization = pipeline({"waveform": waveform, "sample_rate": sample_rate})  
    speak = []  

    for speech_turn, _, speaker in diarization.itertracks(yield_label=True):
        speak.append([[speaker], [speech_turn.start, speech_turn.end]])

    speak = pd.DataFrame(speak, columns=["speaker", "time"])
    speak[["start", "end"]] = pd.DataFrame(speak["time"].to_arrow().to_pylist(), index=speak.index)
    speak.drop(columns=["time"], inplace=True)

    for i in speak.index:
        if i== 0:
            continue
        if speak["speaker"][i-1]== speak["speaker"][i]:
            speak["start"][i]= speak["start"][i-1]
            speak.drop(i-1,inplace=True)
    speak.reset_index(drop=True,inplace=True)
    
    wf = wave.open(file, "rb")
    rec = KaldiRecognizer(model, wf.getframerate())
    rec.SetWords(True)
    results = []
    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            part_result = json.loads(rec.Result())
            results.append(part_result)
    part_result = json.loads(rec.FinalResult())
    results.append(part_result)

    text = []
    for i in results:
        try:
            for ii in i["result"]:
                text.append([ii["word"], ii["start"], ii["end"]])
        except:
            continue

    df_text = pd.DataFrame(text, columns=["word", "start", "end"])

    df = pd.concat([speak, pd.DataFrame(columns=["text", "happy"])], axis=1)
    for i in speak.index:
        df_text_filtered = df_text[(df_text["start"] > speak["start"][i]) & (df_text["end"] < speak["end"][i])]
        df.loc[i, "text"] = " ".join([f"{x}" for x in df_text_filtered["word"].values_host])
        df.loc[i, "happy"] = duygu_analizi_yap(df.loc[i, "text"])
    
    return df.drop(index=df[df["text"] == ""].to_pandas().index).reset_index(drop=True)

class AudioFileUploadView(APIView):
    def post(self, request, *args, **kwargs):
        file_serializer = AudioFileSerializer(data=request.data)
        if file_serializer.is_valid():
            file_instance = file_serializer.save()
            file_url = request.build_absolute_uri(file_instance.file.url)

            sort= "/home/kaplan/Desktop/sound_class/django_api"
            
            train=f"{sort}{file_instance.file.url}"
            test= "/home/kaplan/Downloads/speech.wav"
            try:
                frekans(train)
                df= sound(train)
                Person.objects.all().delete()
                
                print(df)
                person = Person(
                    name="Konu",
                    mesaj=" ".join([f"{x}" for x in konu_tespiti_tfidf(" ".join([f"{x}" for x in df["text"].values_host]))]),
                    time_start=0,
                    time=0,
                    time_end=0,
                    happy=0
                )
                print(" ".join([f"{x}" for x in konu_tespiti_tfidf(" ".join([f"{x}" for x in df["text"].values_host]))]))
                person.save()
                for i in df.index:
                    person = Person(
                        name=str(df.loc[i, "speaker"])[2:-2],
                        mesaj=df.loc[i, "text"],
                        time_start=df.loc[i, "start"],
                        time=(df.loc[i, "end"] - df.loc[i, "start"]),
                        time_end=df.loc[i, "end"],
                        happy=df.loc[i, "happy"]
                    )
                    person.save()
            except Exception as e:
                print(f"Hata Oldu: {e}")
                return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            serializer = PersonSerializer(person)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PersonViewSet(viewsets.ModelViewSet):
    queryset = Person.objects.all()
    serializer_class = PersonSerializer
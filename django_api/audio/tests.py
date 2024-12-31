import unittest
import tempfile
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from audio.views import duygu_analizi_yap, konu_tespiti_tfidf, frekans

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_api.settings')
import django
django.setup()

class TestDuyguAnaliziYap(unittest.TestCase):
    def test_duygu_analizi_yap(self):
        pozitif_metin = "I love this!"
        negatif_metin = "I hate this!"
        notr_metin = "This is a pen."

        self.assertEqual(duygu_analizi_yap(pozitif_metin), 1)
        self.assertEqual(duygu_analizi_yap(negatif_metin), -1)
        self.assertEqual(duygu_analizi_yap(notr_metin), 0)
        self.assertIsNone(duygu_analizi_yap(""))

class TestKonuTespitiTFIDF(unittest.TestCase):
    def test_konu_tespiti_tfidf(self):
        metin = "This is a test sentence for TFIDF vectorizer."
        sonuc = konu_tespiti_tfidf(metin, en_fazla=3)
        self.assertEqual(len(sonuc), 3)
        self.assertIn("test", sonuc)
        self.assertIn("sentence", sonuc)
        self.assertIn("tfidf", sonuc)

class TestFrekans(unittest.TestCase):
    def test_frekans(self):
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as temp_audio:
            temp_audio.write(b"Fake audio data")
            temp_audio.seek(0)
            temp_audio_path = temp_audio.name

        try:
            sonuc = frekans(temp_audio_path)
            self.assertIsNotNone(sonuc)
        except Exception as e:
            self.fail(f"Frekans function failed with error: {e}")
        finally:
            os.remove(temp_audio_path)

if __name__ == '__main__':
    unittest.main()
class Persons {
  late String name;
  late String mesaj;
  late double timeStart; // double tipi
  late double timeEnd; // double tipi
  late int happy; // -1, 0, 1

  Persons({
    required this.name,
    required this.mesaj,
    required this.timeStart,
    required this.timeEnd,
    required this.happy,
  });

  factory Persons.fromJson(Map<String, dynamic> json) {
    double timeStart = json["time_start"] is String
        ? double.tryParse(json["time_start"]) ?? 0.0
        : json["time_start"].toDouble();
    double timeEnd = json["time_end"] is String
        ? double.tryParse(json["time_end"]) ?? 0.0
        : json["time_end"].toDouble();
    print(
        'timeStart: $timeStart, timeEnd: $timeEnd'); // Debug için print ifadeleri

    return Persons(
      name: json["name"] ?? '',
      mesaj: json["mesaj"] ?? '',
      timeStart: timeStart,
      timeEnd: timeEnd,
      happy: json["happy"] is String
          ? int.tryParse(json["happy"]) ?? 0
          : json["happy"],
    );
  }
}

class SpeakerStatistics {
  final String name;
  final int totalDuration; // Saniye cinsinden konuşma süresi
  final int totalWords; // Toplam kelime sayısı
  final int totalPositiveMessages; // Toplam olumlu mesaj sayısı
  final int totalNegativeMessages; // Toplam olumsuz mesaj sayısı

  SpeakerStatistics({
    required this.name,
    required this.totalDuration,
    required this.totalWords,
    required this.totalPositiveMessages,
    required this.totalNegativeMessages,
  });
}

class PersonStatistics {
  final int totalPersons;
  final int totalPositiveMessages;
  final int totalNeutralMessages;
  final int totalNegativeMessages;
  final int totalTalkDuration; // Saniye cinsinden
  final List<SpeakerStatistics>
      speakerStatistics; // Her konuşmacının istatistikleri

  PersonStatistics({
    required this.totalPersons,
    required this.totalPositiveMessages,
    required this.totalNeutralMessages,
    required this.totalNegativeMessages,
    required this.totalTalkDuration,
    required this.speakerStatistics,
  });
}

PersonStatistics calculateStatistics(List<Persons> personsList) {
  int totalPositiveMessages = 0;
  int totalNeutralMessages = 0;
  int totalNegativeMessages = 0;
  int totalTalkDuration = 0;

  // Benzersiz isimleri bulmak için bir set kullanın
  Set<String> uniqueNames = {};
  Map<String, SpeakerStatistics> speakerStatsMap = {};

  for (var person in personsList) {
    // Benzersiz isimleri set'e ekleyin
    uniqueNames.add(person.name);

    // Olumlu, nötr ve olumsuz mesaj sayısını kontrol et
    if (person.happy == 1) {
      totalPositiveMessages++;
    } else if (person.happy == 0) {
      totalNeutralMessages++;
    } else if (person.happy == -1) {
      totalNegativeMessages++;
    }

    // Konuşma süresi hesaplama
    double duration = person.timeEnd - person.timeStart;
    print(
        'timeStart: ${person.timeStart}, timeEnd: ${person.timeEnd}, duration: $duration'); // Debug için print ifadeleri
    totalTalkDuration += duration.toInt();

    // Kelime sayısını hesaplama
    int wordCount = person.mesaj.split(' ').length;

    // Konuşmacı istatistiklerini güncelleme
    if (!speakerStatsMap.containsKey(person.name)) {
      speakerStatsMap[person.name] = SpeakerStatistics(
        name: person.name,
        totalDuration: duration.toInt(),
        totalWords: wordCount,
        totalPositiveMessages: person.happy == 1 ? 1 : 0,
        totalNegativeMessages: person.happy == -1 ? 1 : 0,
      );
    } else {
      var stats = speakerStatsMap[person.name]!;
      speakerStatsMap[person.name] = SpeakerStatistics(
        name: stats.name,
        totalDuration: stats.totalDuration + duration.toInt(),
        totalWords: stats.totalWords + wordCount,
        totalPositiveMessages:
            stats.totalPositiveMessages + (person.happy == 1 ? 1 : 0),
        totalNegativeMessages:
            stats.totalNegativeMessages + (person.happy == -1 ? 1 : 0),
      );
    }
  }

  return PersonStatistics(
    totalPersons: uniqueNames.length,
    totalPositiveMessages: totalPositiveMessages,
    totalNeutralMessages: totalNeutralMessages,
    totalNegativeMessages: totalNegativeMessages,
    totalTalkDuration: totalTalkDuration,
    speakerStatistics: speakerStatsMap.values.toList(),
  );
}

class Persons {
  late String name;
  late String mesaj;
  late double timeStart;
  late double timeEnd;
  late int happy;

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
  final int totalDuration;
  final int totalWords;
  final int totalPositiveMessages;
  final int totalNeutralMessages;
  final int totalNegativeMessages;

  SpeakerStatistics({
    required this.name,
    required this.totalDuration,
    required this.totalWords,
    required this.totalPositiveMessages,
    required this.totalNeutralMessages,
    required this.totalNegativeMessages,
  });
}

class PersonStatistics {
  final int totalPersons;
  final int totalPositiveMessages;
  final int totalNeutralMessages;
  final int totalNegativeMessages;
  final int totalTalkDuration;
  final List<SpeakerStatistics> speakerStatistics;

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

  Set<String> uniqueNames = {};
  Map<String, SpeakerStatistics> speakerStatsMap = {};

  for (var person in personsList) {
    uniqueNames.add(person.name);

    if (person.happy == 1) {
      totalPositiveMessages++;
    } else if (person.happy == 0) {
      totalNeutralMessages++;
    } else if (person.happy == -1) {
      totalNegativeMessages++;
    }

    double duration = person.timeEnd - person.timeStart;
    totalTalkDuration += duration.toInt(); // Toplam konuşma süresini hesapla

    int wordCount = person.mesaj.split(' ').length;

    if (!speakerStatsMap.containsKey(person.name)) {
      speakerStatsMap[person.name] = SpeakerStatistics(
        name: person.name,
        totalDuration: duration.toInt(),
        totalWords: wordCount,
        totalPositiveMessages: person.happy == 1 ? 1 : 0,
        totalNeutralMessages: person.happy == 0 ? 1 : 0,
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
        totalNeutralMessages:
            stats.totalNeutralMessages + (person.happy == 0 ? 1 : 0),
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

import 'package:flutter/material.dart';
import '../models/persons_item.dart';
import '../services/fetch_persons.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<PersonStatistics> statistics;

  @override
  void initState() {
    super.initState();
    statistics = fetchPersons().then((personsList) {
      return calculateStatistics(personsList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Statistics'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        elevation: 4.0,
      ),
      body: FutureBuilder<PersonStatistics>(
        future: statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          } else if (snapshot.hasData) {
            final stats = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildStatisticCard(
                    title: 'Total Persons',
                    value: stats.totalPersons,
                    icon: Icons.group,
                    color: Colors.teal,
                  ),
                  buildStatisticCard(
                    title: 'Total Positive Messages',
                    value: stats.totalPositiveMessages,
                    icon: Icons.thumb_up,
                    color: Colors.green,
                  ),
                  buildStatisticCard(
                    title: 'Total Neutral Messages',
                    value: stats.totalNeutralMessages,
                    icon: Icons.horizontal_rule,
                    color: Colors.blue,
                  ),
                  buildStatisticCard(
                    title: 'Total Negative Messages',
                    value: stats.totalNegativeMessages,
                    icon: Icons.thumb_down,
                    color: Colors.red,
                  ),
                  buildStatisticCard(
                    title: 'Total Talk Duration',
                    value: '${stats.totalTalkDuration} seconds',
                    icon: Icons.timer,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Speaker Statistics',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  const SizedBox(height: 10),
                  ...stats.speakerStatistics.map((speaker) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 6.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              speaker.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total duration: ${speaker.totalDuration} seconds',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Total words: ${speaker.totalWords}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 12),
                            buildMessageTypeBar(
                              speaker.totalPositiveMessages,
                              speaker.totalNeutralMessages,
                              speaker.totalNegativeMessages,
                              speaker.totalWords,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildStatisticCard(
      {required String title,
      required dynamic value,
      required IconData icon,
      required Color color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 6.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          '$value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildMessageTypeBar(
    int positiveMessages,
    int neutralMessages,
    int negativeMessages,
    int totalMessages,
  ) {
    final double positivePercentage = (positiveMessages / totalMessages) * 100;
    final double neutralPercentage = (neutralMessages / totalMessages) * 100;
    final double negativePercentage = (negativeMessages / totalMessages) * 100;

    return Row(
      children: [
        Expanded(
          flex: positivePercentage.round(),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
          ),
        ),
        Expanded(
          flex: neutralPercentage.round(),
          child: Container(
            height: 10,
            color: Colors.blue,
          ),
        ),
        Expanded(
          flex: negativePercentage.round(),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

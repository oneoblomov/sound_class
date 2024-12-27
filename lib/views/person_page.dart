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
      body: FutureBuilder<PersonStatistics>(
        future: statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final stats = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text('Total persons: ${stats.totalPersons}',
                    style: TextStyle(fontSize: 24)),
                Text('Total positive messages: ${stats.totalPositiveMessages}',
                    style: TextStyle(fontSize: 24)),
                Text('Total neutral messages: ${stats.totalNeutralMessages}',
                    style: TextStyle(fontSize: 24)),
                Text('Total negative messages: ${stats.totalNegativeMessages}',
                    style: TextStyle(fontSize: 24)),
                Text('Total talk duration: ${stats.totalTalkDuration} seconds',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Text('Speaker Statistics:',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ...stats.speakerStatistics.map((speaker) {
                  return ListTile(
                    title: Text(speaker.name, style: TextStyle(fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total duration: ${speaker.totalDuration} seconds'),
                        Text('Total words: ${speaker.totalWords}'),
                        Text(
                            'Total negative messages: ${speaker.totalNegativeMessages}'),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

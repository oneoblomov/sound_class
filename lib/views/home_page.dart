import 'package:flutter/material.dart';

import '../models/persons_item.dart';
import '../services/fetch_persons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HomePage> {
  final Map<String, Color> speakerColors = {
    "['SPEAKER_00']": Colors.blue,
    "['SPEAKER_01']": Colors.lime,
    "['SPEAKER_02']": Colors.cyan,
    "['SPEAKER_03']": Colors.yellow,
    "['SPEAKER_04']": Colors.purple,
    "['SPEAKER_05']": Colors.orange,
    "['SPEAKER_06']": Colors.teal,
    "['SPEAKER_07']": Colors.brown
  };

  final Map<String, Color> happyColors = {
    "-1": Colors.red,
    "0": Colors.black,
    "1": Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildMain()],
      ),
    );
  }

  Widget _buildMain() {
    return FutureBuilder<List<Persons>>(
      future: fetchPersons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: speakerColors[snapshot.data![index].name] ??
                        Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(snapshot.data![index].name
                        .substring(2, snapshot.data![index].name.length - 2)),
                    subtitle: Text(
                      snapshot.data![index].mesaj,
                      style: TextStyle(
                          color: happyColors[snapshot.data![index].happy]),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

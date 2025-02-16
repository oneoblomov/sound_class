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
    "SPEAKER_00": Colors.blueAccent, // Mavi tonları
    "SPEAKER_01": Colors.orangeAccent, // Turuncu
    "SPEAKER_02": Colors.greenAccent, // Yeşil
    "SPEAKER_03": Colors.purpleAccent, // Mor
    "SPEAKER_04": Colors.tealAccent, // Yeşil-mavi tonu
    "SPEAKER_05": Colors.amberAccent, // Altın sarısı
    "SPEAKER_06": Colors.redAccent, // Kırmızı
    "SPEAKER_07": Colors.indigoAccent, // Lacivert
  };

  final Map<String, Color> happyColors = {
    "-1": Colors.redAccent, // Negatif, kırmızı
    "0": Colors.grey, // Nötr, gri
    "1": Colors.greenAccent, // Pozitif, yeşil
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
                    title: Text(snapshot.data![index].name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
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

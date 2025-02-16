import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import 'package:provider/provider.dart';
import '../viewmodels/menu_viewmodel.dart';
import '../services/sendAudioFile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AudioRecorder recorder = AudioRecorder();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Proje'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.red,
        toolbarHeight: 20,
        centerTitle: true,
      ),
      body: Consumer<MenuViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.currentPage;
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isRecording ? 80.0 : 56.0,
          height: isRecording ? 80.0 : 56.0,
          child: FloatingActionButton(
            key: ValueKey<bool>(isRecording),
            onPressed: () async {
              if (isRecording) {
                String? filePath = await recorder.stop();
                if (filePath != null) {
                  sendAudioFile(filePath);
                  setState(() {
                    isRecording = false;
                    recordingPath = filePath;
                  });
                }
              } else {
                if (await recorder.hasPermission()) {
                  final Directory appDocumentsDir =
                      await getApplicationDocumentsDirectory();
                  final String filePath =
                      p.join(appDocumentsDir.path, "recording.wav");
                  await recorder.start(
                    const RecordConfig(),
                    path: filePath,
                  );
                  setState(() {
                    isRecording = true;
                    recordingPath = null;
                  });
                } else {
                  print("Permission not granted");
                }
              }
            },
            backgroundColor: isRecording ? Colors.red : Colors.blue,
            child: Icon(isRecording ? Icons.mic_off : Icons.mic),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Consumer<MenuViewModel>(
        builder: (context, viewModel, child) {
          return BottomNavigationBar(
            items: viewModel.menuItems
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.title,
                    ))
                .toList(),
            currentIndex: viewModel.selectedIndex,
            onTap: viewModel.selectMenuItem,
            fixedColor: Colors.red,
          );
        },
      ),
    );
  }
}

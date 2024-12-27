import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persons_item.dart';
import 'dart:io';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

Future<void> sendAudioFile(String filePath) async {
  var uri = Uri.parse('http://10.39.190.99:8000/audio/upload/');
  var request = http.MultipartRequest('POST', uri);

  var bytes = await File(filePath).readAsBytes();

  request.files.add(
    http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'audio.wav',
      contentType: MediaType('audio', 'wav'),
    ),
  );

  try {
    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      var personData = json.decode(responseData);
      Persons person = Persons.fromJson(personData);
      print('Received person data: ${person.name}, ${person.mesaj}');
    } else {
      print('Error! Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending audio file: $e');
  }
}

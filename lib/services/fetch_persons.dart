import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persons_item.dart';

Future<List<Persons>> fetchPersons({http.Client? client}) async {
  client ??= http.Client();
  var uri = Uri.parse('http://10.39.190.99:8000/audio/persons/');
  var response = await client.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Persons.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load persons');
  }
}

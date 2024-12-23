import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persons_item.dart';

Future<List<Persons>> fetchPersons() async {
  var uri = Uri.parse('http://10.39.190.61:8000/audio/persons/');
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    print('Fetched data: $data'); // JSON verilerini yazdır
    return data.map((json) => Persons.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load persons');
  }
}

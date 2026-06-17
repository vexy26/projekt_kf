import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class DisneyApiService {
  static const String baseUrl = "https://api.disneyapi.dev";

  // pobranie calej listy postaci
  static Future<List<DisneyCharacter>> fetchCharacters() async {
    final response = await http.get(
      Uri.parse("$baseUrl/character"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List characters = data["data"]; //cala lista jest w data

      // przechodzymy przez elementy listy i zamieniamy na obiekt z klasy
      return characters.map((character) {
        return DisneyCharacter.fromMap(character);
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }

  // pobranie szczegolow danej postaci - https://api.disneyapi.dev/character/id
  static Future<DisneyCharacter> fetchCharacterInfo(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/character/$id"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // zwraca jedna mape z danymi danej postaci w data
      final Map characterInfo = data["data"];

      return DisneyCharacter.fromMap(characterInfo);
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}
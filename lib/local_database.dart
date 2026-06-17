import 'package:hive_ce/hive.dart';

import 'character.dart';

class DisneyLocalDatabase {
  // pobieramy box otworzony przez nas w main
  static Box get _box => Hive.box("characters");


  // Do ekranu glownego - mniej szczegolowe
  static List<DisneyCharacter> getCharacter() {
    // zwraca wszystkie wartości zapisane w boxie
    return _box.values.map((item) {
      return DisneyCharacter.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  static Future<void> saveCharacters(List<DisneyCharacter> characters) async {
    // zapisuje postac pod kluczem równym jego id
    for (final character in characters) {
      await _box.put(character.id, character.toMap()); // aktualizuje postacie
    }
  }

  // Do ekranu szczegolow
  static DisneyCharacter? getCharacterInfo(int id){
    // szukanie danego id
    final item = _box.get(id);

    if (item != null){
      return DisneyCharacter.fromMap(Map<String, dynamic>.from(item));
    }

    return null; //jesli nie znajdziemy
  }

  static Future<void> saveCharacterInfo(DisneyCharacter character) async {
    await _box.put(character.id, character.toMap()); // aktualizuje postac
  }

  static bool isEmpty() {
    return _box.isEmpty;
  }
}
/*
[
  {
    "_id": 112, !!!!!!!!!!!!!!!!!!
    "films": [
      "Hercules (film)"
    ],
    "shortFilms": [],
    "tvShows": [
      "Hercules (TV series)"
    ],
    "videoGames": [
      "Kingdom Hearts III"
    ],
    "parkAttractions": [],
    "allies": [],
    "enemies": [],
    "name": "Achilles", !!!!!!!!!!!!!!!!
    "imageUrl": "https://static.wikia.nocookie.net/disney/images/6/67/HATS_Achilles.png", !!!!!!!!!!!
    "url": "https://api.disneyapi.dev/characters/112"
  },
*/

class DisneyCharacter {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> films;
  final List<String> shortFilms;
  final List<String> tvShows;
  final List<String> videoGames;
  final List<String> parkAttractions;
  final List<String> allies;
  final List<String> enemies;

  DisneyCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.films,
    required this.shortFilms,
    required this.tvShows,
    required this.videoGames,
    required this.parkAttractions,
    required this.allies,
    required this.enemies,
  });

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "imageUrl": imageUrl,
      "films": films,
      "shortFilms": shortFilms,
      "tvShows": tvShows,
      "videoGames": videoGames,
      "parkAttractions": parkAttractions,
      "allies": allies,
      "enemies": enemies,
    };
  }
  factory DisneyCharacter.fromMap(Map map) {
    return DisneyCharacter(
      id: map["_id"] ?? 0,
      name: map["name"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      films: List<String>.from(map["films"] ?? []),
      shortFilms: List<String>.from(map["shortFilms"] ?? []),
      tvShows: List<String>.from(map["tvShows"] ?? []),
      videoGames: List<String>.from(map["videoGames"] ?? []),
      parkAttractions: List<String>.from(map["parkAttractions"] ?? []),
      allies: List<String>.from(map["allies"] ?? []),
      enemies: List<String>.from(map["enemies"] ?? []),
    );
  }

}

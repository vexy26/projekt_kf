import 'package:flutter/material.dart';
import 'character.dart';
import 'api_service.dart';
import 'local_database.dart';

class InfoScreen extends StatefulWidget {
  final DisneyCharacter character;

  const InfoScreen({super.key, required this.character});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late Future<DisneyCharacter> characterInfoFuture; // przechowuje wynik ladowania danych

  @override
  void initState() {
    super.initState();
    characterInfoFuture = loadInfo();  // ladowanie przy starcie dla konkretnego id
  }

  Future<DisneyCharacter> loadInfo() async {
    try {
      // pobieranie szczegolow
      final data = await DisneyApiService.fetchCharacterInfo(widget.character.id);
      // zapisanie do bazy
      await DisneyLocalDatabase.saveCharacterInfo(data);
      return data;
    }
    catch (e) {
      final localData = DisneyLocalDatabase.getCharacterInfo(widget.character.id);
      return localData ?? widget.character; // przy problemach z siecia czytamy z bazy danych
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disney Characters"),
      ),
      body: FutureBuilder<DisneyCharacter>(
        future: characterInfoFuture,
        builder: (context, snapshot) {
          // ładowanie
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // errorr
          else if (snapshot.hasError) {
            return Center(
              child: Text("Błąd: ${snapshot.error}"),
            );
          }

          // wszystko okej - pobieramy dane
          final character = snapshot.data!;

          return ListView(
              padding: const EdgeInsets.all(16.0),
                children: [
                  Center( // zdjecie na srodku
                    child: character.imageUrl.isNotEmpty
                        ? Image.network( // jesli jest link probujemy zaladowac zdjeice
                            character.imageUrl,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 100); // jesli link nie dziala (zdjecie zostalo np usuniete) dajemy domyslna ikonke
                          },
                        )
                        : const Icon(Icons.person, size: 100), // jesli nie bylo linku od poczatku, od razu wrzucamy ikonke domyslna
                  ),

                  // odstep
                  const SizedBox(height: 30),

                  // name, listy: films, shortfilms, tvShows, videoGames, parkAttractions,allies,enemies

                  // imie - name
                  const Text("Nazwa postaci:"),
                  // jesli jest wyswietlamy imie, w przypadku gdyby go nie bylo wyswietlamy napis o braku informacji
                  Text(character.name.isNotEmpty
                    ? character.name
                    : "Brak informacji"),

                  const SizedBox(height: 10),

                  // filmy - films
                  const Text("Filmy:"),
                  if (character.films.isEmpty)
                    const Text("- Brak")
                  else
                    for (final film in character.films)
                      Text("-$film"),

                  const SizedBox(height: 10),

                  // krótkie filmy / filmy krótkometrażowe - shortFilms
                  const Text("Filmy krótkometrażowe:"),
                  if (character.shortFilms.isEmpty)
                    const Text("- Brak")
                  else
                    for (final shortFilm in character.shortFilms)
                      Text("-$shortFilm"),

                  const SizedBox(height: 10),

                  // seriale - tvShows
                  const Text("Seriale:"),
                  if (character.tvShows.isEmpty)
                    const Text("- Brak")
                  else
                    for (final tvShow in character.tvShows)
                      Text("-$tvShow"),

                  const SizedBox(height: 10),

                  // gry - videoGames
                  const Text("Gry:"),
                  if (character.videoGames.isEmpty)
                    const Text("- Brak")
                  else
                    for (final videoGame in character.videoGames)
                      Text("-$videoGame"),

                  const SizedBox(height: 10),

                  // atrakcje - parkAttractions
                  const Text("Atrakcje w parku:"),
                  if (character.parkAttractions.isEmpty)
                    const Text("- Brak")
                  else
                    for (final parkAttraction in character.parkAttractions)
                      Text("-$parkAttraction"),

                  const SizedBox(height: 10),

                  // sojusznicy - allies
                  const Text("Sojusznicy:"),
                  if (character.allies.isEmpty)
                    const Text("- Brak")
                  else
                    for (final ally in character.allies)
                      Text("-$ally"),

                  const SizedBox(height: 10),

                  // wrogowie - enemies
                  const Text("Wrogowie:"),
                  if (character.enemies.isEmpty)
                    const Text("- Brak")
                  else
                    for (final enemy in character.enemies)
                      Text("-$enemy"),

                  const SizedBox(height: 30),
                ],
          );
        },
      ),
    );
  }
}
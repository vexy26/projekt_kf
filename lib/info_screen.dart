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
                        ? ClipRRect( // do przyciecia - zaokraglonych rogow
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network( // jesli jest link probujemy zaladowac zdjeice
                            character.imageUrl,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 100); // jesli link nie dziala (zdjecie zostalo np usuniete) dajemy domyslna ikonke
                            },
                          ),
                        )
                        : const Icon(Icons.person, size: 100), // jesli nie bylo linku od poczatku, od razu wrzucamy ikonke domyslna
                  ),

                  // odstep
                  const SizedBox(height: 30),

                  // name, listy: films, shortfilms, tvShows, videoGames, parkAttractions,allies,enemies

                  // imie - name
                  Center(
                    child: Text(
                      character.name.isNotEmpty ? character.name : "Brak informacji",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // filmy - films
                  Card (
                    elevation: 2.0, // wysokosc ciena
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                        child: Column (
                          crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                          children: [
                            const Text(
                                "Filmy:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (character.films.isEmpty)
                              const Text("- Brak")
                            else
                              for (final film in character.films)
                                Text("- '$film'"),
                          ],
                        )
                    ),
                  ),


                  const SizedBox(height: 10),

                  // krótkie filmy / filmy krótkometrażowe - shortFilms
                  Card (
                    elevation: 2.0, // wysokosc ciena
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                        children: [
                          const Text(
                            "Filmy krótkometrażowe:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (character.shortFilms.isEmpty)
                            const Text("- Brak")
                          else
                            for (final shortFilm in character.shortFilms)
                              Text("- '$shortFilm'"),
                        ],
                      )
                    ),
                  ),

                  const SizedBox(height: 10),

                  // seriale - tvShows
                  Card (
                  elevation: 2.0, // wysokosc ciena
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                  child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                  children: [
                  const Text(
                  "Seriale:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (character.tvShows.isEmpty)
                  const Text("- Brak")
                  else
                  for (final tvShow in character.tvShows)
                  Text("- '$tvShow'"),
                  ],
                  )
                  ),
                  ),

                  const SizedBox(height: 10),

                  // gry - videoGames
                  Card (
                  elevation: 2.0, // wysokosc ciena
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                  child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                  children: [
                  const Text(
                  "Gry:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (character.videoGames.isEmpty)
                  const Text("- Brak")
                  else
                  for (final videoGame in character.videoGames)
                  Text("-$videoGame"),
                  ],
                  )
                  ),
                  ),

                  const SizedBox(height: 10),

                  // atrakcje - parkAttractions
                  Card (
                  elevation: 2.0, // wysokosc ciena
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                  child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                  children: [
                  const Text(
                  "Atrakcje w parku:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (character.parkAttractions.isEmpty)
                  const Text("- Brak")
                  else
                  for (final parkAttraction in character.parkAttractions)
                  Text("- '$parkAttraction'"),
                  ],
                  )
                  ),
                  ),

                  const SizedBox(height: 10),

                  // sojusznicy - allies
                  Card (
                  elevation: 2.0, // wysokosc ciena
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                  child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                  children: [
                  const Text(
                  "Sojusznicy:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (character.allies.isEmpty)
                  const Text("- Brak")
                  else
                  for (final ally in character.allies)
                  Text("- '$ally'"),
                  ],
                  )
                  ),
                  ),

                  const SizedBox(height: 10),

                  // wrogowie - enemies
                  Card (
                  elevation: 2.0, // wysokosc ciena
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // zaokraglanie rogow
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0), // odstep wewnwatrz
                  child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start, //rownamy do lewej strony
                  children: [
                  const Text(
                  "Wrogowie:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (character.enemies.isEmpty)
                  const Text("- Brak")
                  else
                  for (final enemy in character.enemies)
                  Text("- '$enemy'"),
                  ],
                  )
                  ),
                  ),

                  const SizedBox(height: 30),
                ],
          );
        },
      ),
    );
  }
}
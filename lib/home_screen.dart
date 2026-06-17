import 'package:flutter/material.dart';
import 'character.dart';
import 'api_service.dart';
import 'local_database.dart';
import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DisneyCharacter>> charactersFuture; // przechowuje wynik ladowania danych

  @override
  void initState() {
    super.initState();
    charactersFuture = loadCharacters();  // ladowanie przy starcie
  }

  Future<List<DisneyCharacter>> loadCharacters() async {
    try {
      // pobieranie calej listy
      final data = await DisneyApiService.fetchCharacters();
      // zapisanie do bazy
      await DisneyLocalDatabase.saveCharacters(data);
      return data;
    }
    catch (e) {
      return DisneyLocalDatabase.getCharacter(); // przy problemach z siecia czytamy z bazy danych
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disney Characters"),
      ),
      body: FutureBuilder<List<DisneyCharacter>>(
        future: charactersFuture,
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

          // wszystko okej
          final characters = snapshot.data  ?? [];

          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];

              return ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoScreen(character: character),
                      ),
                    );
                  },
                  // ikona po lewej + zabezpieczenie przed bledem
                  //  poprzednio: leading: character.imageUrl.isNotEmpty ? Image.network(character.imageUrl) : const Icon(Icons.person), - !wrzucal przekreslone linki - dostaje rzeczywiscie link, ale zdjecie moglo zostac usuniete!
                  // zabezpieczenie, ze nawet jesli jest link, to musi byc dobry - w przypadku gdy np. zdjecie zostalo usuniete
                  leading: character.imageUrl.isNotEmpty //sprawdzamy czy jest link
                      ? Image.network( // jesli jest link probujemy zaladowac zdjeice
                        character.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person); // jesli link nie dziala (zdjecie zostalo np usuniete) dajemy domyslna ikonke
                        },
                      )
                      : const Icon(Icons.person), // jesli nie bylo linku od poczatku, od razu wrzucamy ikonke domyslna
                  title: Text(character.name), // nazwa
                  trailing: Icon(Icons.chevron_right) // element po prawej
              );
            },
          );
        },
      ),
    );
  }
}

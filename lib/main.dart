import 'package:flutter/material.dart';
import 'AddGamePage/add_game_page.dart';
import 'AddGamePage/add_wishlist_page.dart';
import 'GamePage/game_list_page.dart';
import 'WishlistPage/wishlist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque de Jeux',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Bibliothèque de Jeux'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenue dans votre bibliothèque de jeux',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameCollectionPage()),
                );
              },
              icon: const Icon(Icons.videogame_asset),
              label: const Text("Voir ma collection de jeux"),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text("Voir ma wishlist"),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddGamePage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un nouveau jeu"),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddWishlistPage()),
                );
              },
              icon: const Icon(Icons.add_box),
              label: const Text("Ajouter à la wishlist"),
            ),
          ],
        ),
      ),
    );
  }
}

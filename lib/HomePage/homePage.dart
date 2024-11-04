import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque de Jeux',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma Bibliothèque de Jeux'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Titre de l'application
            Text(
              'Bienvenue dans votre bibliothèque de jeux',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Bouton pour voir la liste des jeux
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour accéder à la liste des jeux
              },
              icon: Icon(Icons.videogame_asset),
              label: Text("Voir ma collection de jeux"),
            ),

            SizedBox(height: 20),

            // Bouton pour accéder à la wishlist
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour accéder à la wishlist
              },
              icon: Icon(Icons.favorite),
              label: Text("Voir ma wishlist"),
            ),

            SizedBox(height: 20),

            // Bouton pour ajouter un jeu
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour ajouter un jeu
              },
              icon: Icon(Icons.add),
              label: Text("Ajouter un nouveau jeu"),
            ),
          ],
        ),
      ),
    );
  }
}

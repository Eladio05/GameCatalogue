import 'package:flutter/material.dart';
import '../Providers/game_provider.dart';
import '../Models/game_model.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  // Méthode pour récupérer les jeux depuis la base de données
  void _fetchGames() async {
    final games = await GameProvider().getGames();
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Connexion à la BDD'),
      ),
      body: _games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            title: Text(game.title),
            subtitle: Text('Status: ${game.status} | Heures jouées: ${game.hoursPlayed}'),
          );
        },
      ),
    );
  }
}

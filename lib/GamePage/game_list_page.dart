import 'package:flutter/material.dart';
import '../EditPage/edit_page.dart';
import '../GameDetails/game_details_page.dart';
import '../Providers/game_provider.dart';
import '../Models/game_model.dart';
import '../Providers/game_categorie_provider.dart';
import '../Providers/game_plateforme_provider.dart';
import 'game_card.dart';

class GameCollectionPage extends StatefulWidget {
  const GameCollectionPage({super.key});

  @override
  GameCollectionPageState createState() => GameCollectionPageState();
}

class GameCollectionPageState extends State<GameCollectionPage> {
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  void _fetchGames() async {
    final games = await GameProvider().getGames();
    setState(() {
      _games = games;
    });
  }

  // Méthode publique pour mettre à jour la liste des jeux
  void fetchGames() {
    _fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 29),
      body: _games.isEmpty
          ? const Center(
        child: Text(
          'Aucun jeu enregistré',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailsPage(game: game),
                ),
              );
            },
            child: GameCard(
              game: game,
              onDelete: _deleteGame,
              onEdit: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGamePage(game: game),
                  ),
                );

                if (result == true) {
                  _fetchGames();
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _deleteGame(Game game) async {
    await GameCategorieProvider().deleteGameCategorie(game.id!);
    await GamePlateformeProvider().deleteGamePlateforme(game.id!);
    await GameProvider().deleteGame(game.id!);
    _fetchGames();
  }
}

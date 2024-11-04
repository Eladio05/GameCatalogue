import 'package:flutter/material.dart';
import '../EditPage/edit_page.dart';
import '../GameDetails/game_details_page.dart';
import '../Providers//game_provider.dart';
import '../Models/game_model.dart';
import 'dart:io';
import '../Providers/game_categorie_provider.dart';
import '../Providers/game_plateforme_provider.dart';

class GameCollectionPage extends StatefulWidget {
  const GameCollectionPage({super.key});

  @override
  _GameCollectionPageState createState() => _GameCollectionPageState();
}

class _GameCollectionPageState extends State<GameCollectionPage> {
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Collection de Jeux'),
      ),
      body: _games.isEmpty
          ? const Center(child: Text('Aucun jeu enregistré'))
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


class GameCard extends StatelessWidget {
  final Game game;
  final void Function(Game) onDelete;
  final VoidCallback onEdit;

  const GameCard({Key? key, required this.game, required this.onDelete, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: game.imagePath.startsWith('/data/user')
                ? Image.file(
              File(game.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 80);
              },
            )
                : Image.asset(
              game.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 80);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  game.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete(game);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Modifier'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Supprimer'),
                    ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


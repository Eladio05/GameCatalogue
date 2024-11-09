import 'package:flutter/material.dart';
import '../Models/game_model.dart';
import 'dart:io';

class GameCard extends StatelessWidget {
  final Game game;
  final void Function(Game) onDelete;
  final VoidCallback onEdit;

  const GameCard({
    Key? key,
    required this.game,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 40, 40, 40),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 173, 20, 87)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: game.imagePath.startsWith('/data/user')
                  ? Image.file(
                File(game.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80, color: Colors.white);
                },
              )
                  : Image.asset(
                game.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80, color: Colors.white);
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
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
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
                    }
                    else if (value == 'delete') {
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
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

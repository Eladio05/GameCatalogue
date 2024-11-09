import 'package:flutter/material.dart';
import 'dart:io';
import '../Models/wishlist_model.dart';

class WishlistCard extends StatelessWidget {
  final Wishlist wish;
  final void Function(Wishlist) onDelete;
  final VoidCallback onEdit;

  const WishlistCard({
    Key? key,
    required this.wish,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 40, 40, 40),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 138, 43, 226)), // Violet border
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
              child: wish.imagePath.startsWith('/data/user')
                  ? Image.file(
                File(wish.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
              )
                  : Image.asset(
                wish.imagePath,
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
                    wish.gameTitle,
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
                      onDelete(wish);
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
                  icon: const Icon(Icons.more_vert, color: Color.fromARGB(255, 138, 43, 226)), // Violet icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

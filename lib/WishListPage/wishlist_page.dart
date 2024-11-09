import 'package:flutter/material.dart';
import '../Providers/wishlist_categorie_provider.dart';
import '../Providers/wishlist_plateforme_provider.dart';
import '../WishlistDetails/wishlist_details_page.dart';
import '../Providers/wishlist_provider.dart';
import '../EditPage/edit_wishlist_page.dart';
import 'dart:io';
import '../Models/wishlist_model.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Wishlist> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  void _fetchWishlist() async {
    final wishlist = await WishlistProvider().getWishlist();
    setState(() {
      _wishlist = wishlist;
    });
  }

  void _editWish(Wishlist wish) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWishlistPage(wish: wish),
      ),
    );

    if (result == true) {
      _fetchWishlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _wishlist.isEmpty
          ? const Center(child: Text('Aucun jeu dans la wishlist'))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: _wishlist.length,
        itemBuilder: (context, index) {
          final wish = _wishlist[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistDetailsPage(wish: wish),
                ),
              );
            },
            child: WishlistCard(
              wish: wish,
              onDelete: _deleteWish,
              onEdit: () => _editWish(wish),
            ),
          );
        },
      ),
    );
  }

  void _deleteWish(Wishlist wish) async {
    await WishlistCategorieProvider().deleteWishlistCategorie(wish.id!);
    await WishlistPlateformeProvider().deleteWishlistPlateforme(wish.id!);
    await WishlistProvider().deleteWishlist(wish.id!);
    _fetchWishlist();
  }
}

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
        color: const Color(0xFF282828), // Slightly lighter background for cards
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2)), // Violet border for Wishlist
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
                    } else if (value == 'delete') {
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
                  icon: const Icon(Icons.more_vert, color: Color(0xFF8A2BE2)), // Violet icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

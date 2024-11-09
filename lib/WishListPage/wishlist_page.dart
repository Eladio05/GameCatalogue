import 'package:flutter/material.dart';
import '../Providers/wishlist_categorie_provider.dart';
import '../Providers/wishlist_plateforme_provider.dart';
import '../WishlistDetails/wishlist_details_page.dart';
import '../Providers/wishlist_provider.dart';
import '../EditPage/edit_wishlist_page.dart';
import '../Models/wishlist_model.dart';
import 'wishlist_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  List<Wishlist> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  void fetchWishlist() {
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

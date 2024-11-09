class WishlistCategorie {
  final int wishlistId;
  final int categoryId;

  WishlistCategorie({required this.wishlistId, required this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'idWishList': wishlistId,
      'idCategorie': categoryId,
    };
  }

  factory WishlistCategorie.fromMap(Map<String, dynamic> map) {
    return WishlistCategorie(
      wishlistId: map['idWishList'],
      categoryId: map['idCategorie'],
    );
  }
}

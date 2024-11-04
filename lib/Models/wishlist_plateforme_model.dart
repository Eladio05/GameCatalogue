class WishlistPlateforme {
  final int wishlistId;
  final int platformId;

  WishlistPlateforme({required this.wishlistId, required this.platformId});

  // Convertir en Map pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'idWishList': wishlistId,
      'idPlateforme': platformId,
    };
  }

  // Convertir un Map en WishlistPlatform
  factory WishlistPlateforme.fromMap(Map<String, dynamic> map) {
    return WishlistPlateforme(
      wishlistId: map['idWishList'],
      platformId: map['idPlateforme'],
    );
  }
}

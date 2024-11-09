class WishlistPlateforme {
  final int wishlistId;
  final int platformId;

  WishlistPlateforme({required this.wishlistId, required this.platformId});

  Map<String, dynamic> toMap() {
    return {
      'idWishList': wishlistId,
      'idPlateforme': platformId,
    };
  }

  factory WishlistPlateforme.fromMap(Map<String, dynamic> map) {
    return WishlistPlateforme(
      wishlistId: map['idWishList'],
      platformId: map['idPlateforme'],
    );
  }
}

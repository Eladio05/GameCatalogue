class Wishlist {
  final int? id;
  final String gameTitle;
  final int priority;
  final String dateAdded;
  final String imagePath;

  Wishlist({
    this.id,
    required this.gameTitle,
    required this.priority,
    required this.dateAdded,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'idWishList': id,
      'titreJeu': gameTitle,
      'priorite': priority,
      'date_ajout': dateAdded,
      'image_path': imagePath,
    };
  }

  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      id: map['idWishList'],
      gameTitle: map['titreJeu'],
      priority: map['priorite'],
      dateAdded: map['date_ajout'],
      imagePath: map['image_path'],
    );
  }
}


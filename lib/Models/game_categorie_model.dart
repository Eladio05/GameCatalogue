class GameCategorie {
  final int gameId;
  final int categoryId;

  GameCategorie({required this.gameId, required this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'idJeu': gameId,
      'idGenre': categoryId,
    };
  }

  factory GameCategorie.fromMap(Map<String, dynamic> map) {
    return GameCategorie(
      gameId: map['idJeu'],
      categoryId: map['idGenre'],
    );
  }
}


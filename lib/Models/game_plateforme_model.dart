class GamePlateforme {
  final int gameId;
  final int platformId;

  GamePlateforme({required this.gameId, required this.platformId});

  // Convertir en Map pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'idJeu': gameId,
      'idPlateforme': platformId,
    };
  }

  // Convertir un Map en GamePlatform
  factory GamePlateforme.fromMap(Map<String, dynamic> map) {
    return GamePlateforme(
      gameId: map['idJeu'],
      platformId: map['idPlateforme'],
    );
  }
}

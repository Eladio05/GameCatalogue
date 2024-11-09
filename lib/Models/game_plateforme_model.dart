class GamePlateforme {
  final int gameId;
  final int platformId;

  GamePlateforme({required this.gameId, required this.platformId});

  Map<String, dynamic> toMap() {
    return {
      'idJeu': gameId,
      'idPlateforme': platformId,
    };
  }

  factory GamePlateforme.fromMap(Map<String, dynamic> map) {
    return GamePlateforme(
      gameId: map['idJeu'],
      platformId: map['idPlateforme'],
    );
  }
}

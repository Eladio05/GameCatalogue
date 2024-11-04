class Plateforme {
  final int? id;
  final String name;

  Plateforme({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'idPlateforme': id,
      'nomPlateforme': name,
    };
  }

  factory Plateforme.fromMap(Map<String, dynamic> map) {
    return Plateforme(
      id: map['idPlateforme'],
      name: map['nomPlateforme'],
    );
  }
}

class Categorie {
  final int? id;
  final String name;

  Categorie({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'idCategorie': id,
      'nomCategorie': name,
    };
  }

  factory Categorie.fromMap(Map<String, dynamic> map) {
    return Categorie(
      id: map['idCategorie'],
      name: map['nomCategorie'],
    );
  }
}


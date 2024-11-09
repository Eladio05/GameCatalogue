class Game {
  final int? id;
  final String title;
  final String status;
  final int hoursPlayed;
  final String dateAdded;
  final String imagePath;

  Game({
    this.id,
    required this.title,
    required this.status,
    required this.hoursPlayed,
    required this.dateAdded,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'idGame': id,
      'titre': title,
      'status': status,
      'heure_joue': hoursPlayed,
      'date_ajout': dateAdded,
      'image_path': imagePath,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['idGame'],
      title: map['titre'],
      status: map['status'],
      hoursPlayed: map['heure_joue'],
      dateAdded: map['date_ajout'],
      imagePath: map['image_path'],
    );
  }
}

class Destination {
  // 1. Les champs (ajoutez id)
  final String id;          // NOUVEAU
  final String nom;
  final String region;
  final String categorie;
  final String image;
  final double note;
  final int prix;
  final String duree;
  final String description;

  // 2. Le constructeur (ajoutez required this.id)
  const Destination({
    required this.id,       // NOUVEAU
    required this.nom,
    required this.region,
    required this.categorie,
    required this.image,
    required this.note,
    required this.prix,
    required this.duree,
    required this.description,
  });

  // 3. fromJson : collez-le ICI
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'].toString(),
      nom: json['nom'] as String,
      region: json['region'] as String,
      categorie: json['categorie'] as String,
      image: json['image'] as String,
      note: (json['note'] as num).toDouble(),
      prix: (json['prix'] as num).toInt(),
      duree: json['duree'] as String,
      description: json['description'] as String,
    );
  }
} // <- fin de la classe : fromJson doit rester AVANT cette accolade

import 'destination.dart';

class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule;

  const Reservation({
    this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.dateDepart,
    required this.voyageurs,
    required this.formule,
  });

  // Calculer le prix par personne
  int get prixParPersonne {
    return formule == 'Confort'
        ? (destination.prix * 1.3).round()
        : destination.prix;
  }

  // Calculer le prix total
  int get total {
    return prixParPersonne * voyageurs;
  }

  // Transformer la réservation en JSON
  Map<String, dynamic> toJson() {
    return {
      'destinationId': destination.id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'dateDepart': dateDepart.toIso8601String(),
      'voyageurs': voyageurs,
      'formule': formule,
      'total': total,
    };
  }
}

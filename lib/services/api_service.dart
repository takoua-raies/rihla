

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {

  // Construire l'URL
  static Uri _url(String chemin) {
    return Uri.parse('${ApiConfig.baseUrl}$chemin');
  }

  // GET : récupérer toutes les destinations
  static Future<List<Destination>> getDestinations() async {

    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);

    // Vérifier la réponse du serveur
    if (reponse.statusCode != 200) {
      throw Exception(
        'Erreur serveur : ${reponse.statusCode}',
      );
    }

    // Transformer le JSON en liste
    final List<dynamic> liste =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    // Transformer chaque élément en objet Destination
    return liste.map((json) {
      return Destination.fromJson(json);
    }).toList();
  }

  // POST : enregistrer une réservation
  static Future<String> creerReservation(
      Reservation reservation) async {

    final reponse = await http
        .post(
          _url('/reservations'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    // Vérifier si la réservation est créée
    if (reponse.statusCode != 201) {
      throw Exception(
        'Erreur réservation : ${reponse.statusCode}',
      );
    }

    // Récupérer la réponse JSON du serveur
    final Map<String, dynamic> creee =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    // Retourner l'identifiant généré par le serveur
    return creee['id'].toString();
  }
}


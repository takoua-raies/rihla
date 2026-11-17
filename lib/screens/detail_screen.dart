import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import '../widgets/favorite_button.dart';
import 'reservation_screen.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({
    super.key,
    required this.destination,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 1;

  // Ouvrir le formulaire et enregistrer la réservation
  Future<void> _reserver() async {
    // Ouvrir le formulaire de réservation
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _voyageurs,
        ),
      ),
    );

    // Vérifier si l'utilisateur a annulé
    if (reservation == null) return;

    if (!mounted) return;

    final String id;

    // Envoyer la réservation au serveur
    try {
      id = await ApiService.creerReservation(reservation);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Envoi impossible : json-server est-il lancé ?',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      return;
    }

    if (!mounted) return;

    // Afficher la confirmation
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Réservation confirmée !'),
          content: Text(
            'Votre réservation a été enregistrée avec succès.\n\n'
            'N° de réservation : $id',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(
        title: Text(destination.nom),
        actions: [
          // Même état que la carte : tout vient de FavorisModel
          FavoriteButton(destination: destination),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de destination
            Image.asset(
              destination.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom
                  Text(
                    destination.nom,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Région
                  Text(
                    destination.region,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Description
                  Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Prix
                  Text(
                    'Prix : ${destination.prix} DT',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Nombre de voyageurs
                  Row(
                    children: [
                      const Text(
                        'Voyageurs : ',
                        style: TextStyle(fontSize: 16),
                      ),

                      IconButton(
                        onPressed: () {
                          if (_voyageurs > 1) {
                            setState(() {
                              _voyageurs--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),

                      Text(
                        '$_voyageurs',
                        style: const TextStyle(fontSize: 18),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            _voyageurs++;
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Bouton réserver
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _reserver,
                      icon: const Icon(
                        Icons.flight_takeoff,
                      ),
                      label: const Text(
                        'Réserver maintenant',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
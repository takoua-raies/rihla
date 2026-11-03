import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../models/reservation.dart';
import '../screens/reservation_screen.dart';
import '../widgets/favorite_button.dart';

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

  Destination get d => widget.destination;

  Future<void> _reserver() async {
    final Reservation? reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: d,
          voyageurs: _voyageurs,
        ),
      ),
    );

    if (reservation == null || !mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réservation confirmée !'),
        content: Text(
          'Merci ${reservation.nom} !\n\n'
          'Destination : ${reservation.destination.nom}\n'
          'Voyageurs : ${reservation.voyageurs}\n'
          'Formule : ${reservation.formule}\n'
          'Total : ${reservation.total} DT',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: const [
              FavoriteButton(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image-${d.nom}',
                child: Image.asset(
                  d.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.nom,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(d.region),
                      const Spacer(),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text('${d.note}'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    d.description,
                    style: theme.textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _infoItem(
                        Icons.schedule,
                        d.duree,
                      ),
                      const SizedBox(width: 20),
                      _infoItem(
                        Icons.category_outlined,
                        d.categorie,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Nombre de voyageurs',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      IconButton(
                        onPressed: _voyageurs > 1
                            ? () {
                                setState(() {
                                  _voyageurs--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      Text(
                        '$_voyageurs',
                        style: theme.textTheme.titleLarge,
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            _voyageurs++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prix par personne'),
                    Text(
                      '${d.prix} DT',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: _reserver,
                child: const Text('Réserver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(value),
      ],
    );
  }
}


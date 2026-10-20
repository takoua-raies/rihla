import 'package:flutter/material.dart';
import '../models/destination.dart';
import 'favorite_button.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Réponse Q1 (palier 4) : Spacer() est un widget flexible : il prend tout
    // l'espace libre DANS la Row. Pour cela, la Row « note / prix » doit avoir
    // une largeur finie. Sans Expanded, la Column aurait une largeur illimitée
    // (elle suit son contenu) et Spacer ne pourrait pas pousser le prix à
    // droite. Expanded donne à la Column l'espace restant à côté de l'image.
    //
    // Réponse Q2 (palier 4) : aucune ligne à ajouter dans DestinationCard ni
    // dans HomeScreen. Il suffit d'ajouter un 7e objet Destination(...) dans
    // lib/data/destinations.dart, plus son image dans assets/images/.
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                destination.image,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.nom,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 16, color: cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          destination.region,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${destination.note}'),
                      const Spacer(),
                      Text(
                        '${destination.prix} DT',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Palier 6 : bouton favori, dernier enfant de la Row
            const FavoriteButton(),
          ],
        ),
      ),
    );
  }
}
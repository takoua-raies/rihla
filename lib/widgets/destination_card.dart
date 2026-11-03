
import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../screens/detail_screen.dart';
import 'favorite_button.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                destination: destination,
              ),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Row(
            children: [
              // Image avec animation Hero
              Hero(
                tag: 'image-${destination.nom}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    destination.image,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
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
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),

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
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),

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

              // Bouton favori
              const FavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../screens/detail_screen.dart'; // palier 2
import 'favorite_button.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // (vos réponses Q1 et Q2 du palier 4 restent ici, inchangées)

    // Réponse Q1 (palier 2) : le filtre est conservé. La navigation fonctionne
    // comme une PILE : push place DetailScreen PAR-DESSUS HomeScreen, mais
    // HomeScreen reste dans la pile avec son State (donc son filtre). pop
    // retire DetailScreen du sommet et HomeScreen réapparaît tel quel.
    //
    // Réponse Q2 (palier 2) : DetailScreen reçoit la destination par son
    // constructeur : DetailScreen(destination: destination). C'est le même
    // mécanisme qu'au TP 3, où DestinationCard recevait sa Destination en
    // paramètre : un widget reçoit ses données via son constructeur.
    //
    // Réponse Q3 (palier 2) : sans clipBehavior, l'effet d'encre (ripple)
    // déborde des coins arrondis : on voit un éclat rectangulaire qui dépasse
    // de la carte, car l'InkWell dessine sur un rectangle que la Card ne
    // découpe pas.
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias, // l'effet d'encre suit les coins arrondis
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(destination: destination),
            ),
          );
        },
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
      ),
    );
  }
}
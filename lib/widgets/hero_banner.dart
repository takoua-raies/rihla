import 'package:flutter/material.dart';
import '../models/destination.dart';

class HeroBanner extends StatelessWidget {
  final Destination destination;

  const HeroBanner({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // Q1 : si le DecoratedBox est placé en PREMIER dans children, il
    // est au fond du Stack et l'image est dessinée par-dessus : le dégradé
    // devient invisible (caché par l'image) et le texte blanc est moins lisible.
    // Dans un Stack, le premier enfant est au fond, le dernier au premier plan.
    //
    //   Q2 : sans ClipRRect, les coins restent carrés. Le borderRadius
    // n'est appliqué à rien : l'image et le dégradé ne sont plus découpés.
    //
    //  Q3 : right: 130 réserve 130 pixels libres à droite du texte pour
    // le bouton « Découvrir ». Ainsi le texte ne passe jamais sous le bouton.
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Couche 1 : l'image
            Image.asset(destination.image, fit: BoxFit.cover),

            // Couche 2 : dégradé pour la lisibilité du texte blanc
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),

            // TODO 1 : badge blanc avec étoile ambre + note
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // la Row se limite à son contenu
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${destination.note}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TODO 2 : textes en bas à gauche
            Positioned(
              left: 20,
              right: 130,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DESTINATION DU MOIS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    destination.region,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

          
            Positioned(
              right: 16,
              bottom: 20,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Découvrir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
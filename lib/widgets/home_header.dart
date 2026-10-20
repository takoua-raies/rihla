import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  // Q2 : prenom est "final" car un StatelessWidget est immuable :
  // ses paramètres ne changent jamais après la construction. Si la valeur
  // change, Flutter crée un NOUVEAU widget. final garantit cela (et permet
  // aussi le constructeur const).
  final String prenom;

  const HomeHeader({super.key, required this.prenom});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme; 

    return Row(
      children: [
        // Q1 : sans Expanded, la Column prend seulement la largeur de
        // son contenu (le plus long texte). L'avatar se colle donc juste après
        // le texte, au milieu de l'écran, au lieu d'être poussé à l'extrémité
        // droite. Expanded donne à la Column TOUT l'espace restant de la Row.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO 1
              Text(
                'Ahlan, $prenom 👋',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              // TODO 2
              Text(
                "Où partez-vous\naujourd'hui ?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // TODO 3
        CircleAvatar(
          radius: 26,
          backgroundColor: cs.primaryContainer,
          child: Text(
            prenom[0],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ],
    );
  }
}

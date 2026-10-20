import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Q3 : cs.primary est calculée à partir de la seedColor : si on
    // change la seedColor, toute l'interface change de couleur de façon
    // cohérente (et avec un bon contraste). Colors.teal est une couleur fixe,
    // codée en dur : elle ne suit jamais le thème.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Rechercher une destination'),
          ),
          Icon(Icons.tune, color: cs.primary),
        ],
      ),
    );
  }
}
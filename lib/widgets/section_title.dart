import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String titre;
  final String? action; // paramètre OPTIONNEL : peut être null

  const SectionTitle({super.key, required this.titre, this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texteAction = action; // copie locale pour la vérification de null

    return Row(
      children: [
        Expanded(
          child: Text(
            titre,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (texteAction != null)
          TextButton(
            onPressed: () {},
            child: Text(texteAction),
          ),
      ],
    );
  }
}
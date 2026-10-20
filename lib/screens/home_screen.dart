import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          // pas de const devant [ : la liste contient une boucle for
          children: [
            const HomeHeader(prenom: 'Takoua'),
            const SizedBox(height: 20),
            const SearchBox(),
            const SizedBox(height: 20),
            HeroBanner(destination: destinations.first),
            const SizedBox(height: 24),
            const SectionTitle(titre: 'Catégories'),
            // les puces de catégories arrivent au palier 5
            const SizedBox(height: 24),
            const SectionTitle(titre: 'Populaires', action: 'Voir tout'),
            const SizedBox(height: 12),
            for (final d in destinations) DestinationCard(destination: d),
          ],
        ),
      ),
    );
  }
}
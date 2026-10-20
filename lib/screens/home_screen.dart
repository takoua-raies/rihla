
import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Onglet sélectionné : 0 = Explorer
  int _onglet = 0;

  // Contenu de la page d'accueil
  Widget _construireAccueil() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const HomeHeader(prenom: 'Takoua'),

        const SizedBox(height: 20),

        const SearchBox(),

        const SizedBox(height: 24),

        HeroBanner(
          destination: destinations.first,
        ),

        // Si tu as déjà les catégories et les cartes
        // des paliers précédents, ajoute-les ici.
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet == 0
            ? _construireAccueil()
            : Center(
                child: Text(
                  'Bientôt disponible',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
      ),

      // Barre de navigation en bas
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,

        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

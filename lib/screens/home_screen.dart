import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination.dart';
import '../services/api_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  // Réponse 1 : late car le Future est créé dans initState,
  // pas à la déclaration de la variable.
  late Future<List<Destination>> _futurDestinations;

  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations(); // TODO 1
  }

  // Le filtre s'applique à la liste reçue du serveur.
  // Réponse 3 : changer de catégorie ne refait PAS de requête,
  // car setState ne change pas _futurDestinations.
  List<Destination> _filtrer(List<Destination> toutes) =>
      _categorie == 'Tout'
          ? toutes
          : toutes.where((d) => d.categorie == _categorie).toList();

  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur; // FutureBuilder écoute le nouveau Future
    });
    try {
      await futur; // RefreshIndicator attend la fin
    } catch (_) {} // l'erreur est affichée par FutureBuilder
  }

  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        // TODO 2 : en attente et pas encore de données
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        // TODO 3 : erreur
        // Réponse 2 : sans ce test, snapshot.data! vaudrait null
        // et l'application planterait (écran rouge).
        if (snapshot.hasError) {
          return ErreurReseau(
            message: 'Impossible de charger les destinations.',
            onReessayer: _recharger,
          );
        }
        final destinations = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations),
        );
      },
    );
  }

  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        const HomeHeader(prenom: 'Takoua'),
        const SizedBox(height: 20),
        const SearchBox(),
        const SizedBox(height: 20),
        if (destinations.isNotEmpty)
          HeroBanner(destination: destinations.first),
        const SizedBox(height: 24),
        const SectionTitle(titre: 'Catégories'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _categorie == c,
                    onSelected: (_) {
                      setState(() {
                        _categorie = c;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(titre: 'Populaires', action: 'Voir tout'),
        const SizedBox(height: 12),
        for (final d in filtrees)
          DestinationCard(key: ValueKey(d.id), destination: d),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet == 0
            ? _construireExplorer()
            : const Center(child: Text('Bientôt disponible')),
      ),
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

// TODO 4 : écran d'erreur réutilisé au palier 5
class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Vérifiez que json-server est lancé.'),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
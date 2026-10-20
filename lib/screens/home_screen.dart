import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination.dart';
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
  String _categorie = 'Tout'; // l'état : la catégorie choisie

  List<Destination> get _filtrees {
    if (_categorie == 'Tout') return destinations;
    return destinations.where((d) => d.categorie == _categorie).toList();
  }

  // Q1 (palier 5) : sans setState, _categorie change bien en mémoire, mais
  // build() n'est pas rappelé : l'écran ne change pas (puce non cochée,
  // liste identique).
  //
  // Q2 (palier 5) : _filtrees est un getter car il dépend de _categorie, qui
  // change. Recalculé à chaque build(), il est toujours à jour. Une variable
  // calculée une seule fois resterait figée sur l'ancienne catégorie.
  //
  // Q3 (palier 5) : HeroBanner reste un StatelessWidget car il dépend
  // seulement de son paramètre destination, qui ne change pas.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HomeHeader(prenom: 'Takoua'),
            const SizedBox(height: 20),
            const SearchBox(),
            const SizedBox(height: 20),
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
            // Palier 6 : sans clé, Flutter associe chaque State à une POSITION
            // dans la liste. Quand le filtre change la liste, le State du
            // 1er emplacement (son cœur rouge) est réutilisé par la nouvelle
            // 1re carte : le cœur apparaît sur la mauvaise destination ou
            // disparaît. Avec ValueKey(d.nom), Flutter associe le State à la
            // DESTINATION : tant que la carte reste affichée, son cœur la
            // suit, même si sa position change.
            for (final d in _filtrees)
              DestinationCard(key: ValueKey(d.nom), destination: d),
          ],
        ),
      ),
    );
  }
}
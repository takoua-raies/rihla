
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/destination.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  DateTime? _date;

  String _formule = 'Essentiel';

  bool _conditions = false;

  AutovalidateMode _autoValidation =
      AutovalidateMode.disabled;

  // Calcul du prix par personne
  int get _prixParPersonne {
    return _formule == 'Confort'
        ? (widget.destination.prix * 1.3).round()
        : widget.destination.prix;
  }

  // Calcul du prix total
  int get _total {
    return _prixParPersonne * widget.voyageurs;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();

    super.dispose();
  }

  // Decoration des champs
  InputDecoration _deco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Validation du nom
  String? _validerNom(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez votre nom';
    }

    if (value.trim().length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }

    return null;
  }

  // Validation de l'email
  String? _validerEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez votre email';
    }

    final regex = RegExp(
      r'^[\w.+-]+@[\w-]+\.[\w.]+$',
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Email invalide';
    }

    return null;
  }

  // Validation du téléphone
  String? _validerTel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez votre téléphone';
    }

    if (value.trim().length != 8) {
      return 'Le téléphone doit contenir 8 chiffres';
    }

    return null;
  }

  // Ouvrir le calendrier
  Future<void> _choisirDate() async {
    final demain = DateTime.now().add(
      const Duration(days: 1),
    );

    final choisie = await showDatePicker(
      context: context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      helpText: 'Date de départ',
    );

    if (choisie != null) {
      setState(() {
        _date = choisie;

        _dateCtrl.text =
            '${choisie.day.toString().padLeft(2, '0')}/'
            '${choisie.month.toString().padLeft(2, '0')}/'
            '${choisie.year}';
      });
    }
  }

  // Valider le formulaire
  void _valider() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidation =
            AutovalidateMode.onUserInteraction;
      });

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulaire valide'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidation,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Récapitulatif du voyage
              const Text(
                'Votre voyage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    size: 35,
                  ),
                  title: Text(
                    widget.destination.nom,
                  ),
                  subtitle: Text(
                    '${widget.voyageurs} voyageur(s)',
                  ),
                  trailing: Text(
                    '${widget.destination.prix} DT',
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Informations personnelles
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _nomCtrl,
                decoration: _deco(
                  'Nom complet',
                  Icons.person_outline,
                ),
                validator: _validerNom,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _deco(
                  'Adresse email',
                  Icons.email_outlined,
                ),
                validator: _validerEmail,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _telCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: _deco(
                  'Téléphone',
                  Icons.phone_outlined,
                ),
                validator: _validerTel,
              ),

              const SizedBox(height: 25),

              // Date de départ
              const Text(
                'Date de départ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco(
                  'Date de départ',
                  Icons.calendar_month_outlined,
                ),
                validator: (_) {
                  return _date == null
                      ? 'Choisissez une date'
                      : null;
                },
              ),

              const SizedBox(height: 25),

              // Choix de la formule
              const Text(
                'Choisissez votre formule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(
                      Icons.backpack_outlined,
                    ),
                  ),

                  ButtonSegment(
                    value: 'Confort',
                    label: Text('Confort +30 %'),
                    icon: Icon(
                      Icons.hotel_outlined,
                    ),
                  ),
                ],

                selected: {_formule},

                onSelectionChanged: (choix) {
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Conditions d'annulation
              CheckboxListTile(
                value: _conditions,

                onChanged: (v) {
                  setState(() {
                    _conditions = v ?? false;
                  });
                },

                controlAffinity:
                    ListTileControlAffinity.leading,

                contentPadding: EdgeInsets.zero,

                title: const Text(
                  "J'accepte les conditions d'annulation",
                ),

                subtitle: const Text(
                  "Annulation gratuite jusqu'à 48 h avant",
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Barre du bas : prix et bouton
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                '$_prixParPersonne DT × ${widget.voyageurs}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$_total DT',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,

                child: FilledButton(
                  onPressed: _conditions
                      ? _valider
                      : null,

                  child: const Text('Confirmer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

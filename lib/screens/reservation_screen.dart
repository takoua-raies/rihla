
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/destination.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() =>
      _ReservationScreenState();
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

  int get _prixParPersonne {
    return _formule == 'Confort'
        ? (widget.destination.prix * 1.3).round()
        : widget.destination.prix;
  }

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

  
  InputDecoration _deco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  
  String? _validerNom(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez votre nom';
    }

    if (value.trim().length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }

    return null;
  }

  
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

  
  String? _validerTel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez votre téléphone';
    }

    if (value.trim().length != 8) {
      return 'Le téléphone doit contenir 8 chiffres';
    }

    return null;
  }

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

  void _valider() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidation =
            AutovalidateMode.onUserInteraction;
      });

      return;
    }

    if (!_conditions) {
      return;
    }

    final reservation = Reservation(
      destination: widget.destination,
      nom: _nomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      dateDepart: _date!,
      voyageurs: widget.voyageurs,
      formule: _formule,
    );

    Navigator.pop(context, reservation);
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
                  title: Text(widget.destination.nom),
                  subtitle: Text(
                    '${widget.voyageurs} voyageur(s)',
                  ),
                  trailing: Text(
                    '$_prixParPersonne DT',
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Nom
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco(
                  'Nom complet',
                  Icons.person_outline,
                ),
                validator: _validerNom,
              ),

              const SizedBox(height: 15),

              // Email
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

              // Téléphone
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

              const Text(
                'Date de départ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Date
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

              const Text(
                'Choisissez votre formule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Formule
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(Icons.backpack_outlined),
                  ),
                  ButtonSegment(
                    value: 'Confort',
                    label: Text('Confort +30 %'),
                    icon: Icon(Icons.hotel_outlined),
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

              // Conditions
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

      // Prix et bouton
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                '$_prixParPersonne DT × ${widget.voyageurs}',
                style: const TextStyle(fontSize: 16),
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
                  onPressed: _conditions ? _valider : null,
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


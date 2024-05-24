import 'package:flutter/material.dart';
import '../widget/TextField.dart';
import '../widget/VoyageField.dart';
import '../variables/colors.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Nom d\'utilisateur',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: titreColor),
          ),
        ),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: primary,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              Row(
                children: [
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 100,
                        backgroundColor: iconColor,
                        child: CircleAvatar(
                          radius: 95,
                          backgroundColor: inputColor,
                          child: Icon(Icons.person, size: 120),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: informationButtonBackgroudColor,
                          backgroundColor: inputColor,
                        ),
                        child: const Text('Changer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 106),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 500,
                          child: buildTextField('Nouveau nom d\'utilisateur'),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 500,
                          child: buildTextField('Changer d\'adresse mail'),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 500,
                          child: buildTextField('Nouveau mot de passe', obscureText: true),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 500,
                          child: buildTextField('Confirmer mot de passe', obscureText: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: deleteColor),
                      child: const Text('Supprimer votre compte', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: acceptColor),
                      child: const Text('Sauvegarder', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Vos voyages',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: titreColor),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TravelCard(
                    destination: 'Paris',
                    budget: 'Aucun budget',
                    price: '899,16€',
                  ),
                  TravelCard(
                    destination: 'New-York',
                    budget: '1 500€',
                    price: '1 200€',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

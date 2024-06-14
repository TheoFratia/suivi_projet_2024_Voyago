import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/models/user.dart';
import '../widget/TextField.dart';
import '../widget/VoyageField.dart';
import '../variables/colors.dart';
import 'package:projet_dev_mobile/screen/home_screen.dart';
import 'package:projet_dev_mobile/variables/icons.dart';
import 'package:projet_dev_mobile/variables/colors.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chemin absolu vers l'image avatar1.png dans le dossier avatars
    String avatarPath = 'lib/avatars/Avatar1.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Stack(
          children: [
            Center(
              child: Text(
                user.username,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: titreColor),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(iconArrow, color: arrowColor),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              color: primary,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 95,
                            backgroundColor: iconColor,
                            child: CircleAvatar(
                              radius: 90,
                              backgroundColor: inputColor,
                              backgroundImage: FileImage(File(avatarPath)),
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
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Nouveau nom d\'utilisateur'),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Changer d\'adresse mail'),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Nouveau mot de passe', obscureText: true),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Confirmer mot de passe', obscureText: true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: deleteColor),
                            child: const Text('Supprimer votre compte', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 20), // Espacement entre les boutons
                        Flexible( // Utilisation de Flexible pour rendre le bouton "Sauvegarder" flexible
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: acceptColor),
                            child: const Text('Sauvegarder', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Vos voyages',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: titreColor),
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
          );
        },
      ),
    );
  }
}

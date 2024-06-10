import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import '../widget/TextField.dart';
import '../widget/VoyageField.dart';
import '../variables/colors.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String avatarPath = 'assets/avatars/Avatar1.png';
  int avatarId = 2;
  final List<String> avatars = [
    'assets/avatars/Avatar1.png',
    'assets/avatars/Avatar2.png',
    'assets/avatars/Avatar3.png',
    'assets/avatars/Avatar4.png',
    'assets/avatars/Avatar5.png',
    'assets/avatars/Avatar6.png',
    'assets/avatars/Avatar7.png',
    'assets/avatars/Avatar8.png',
    'assets/avatars/Avatar9.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  void _loadAvatar() async {
    final preferences = await SharedPreferences.getInstance();
    avatarId = preferences.getInt('avatarId') ?? 1;
    setState(() {
      avatarPath = 'assets/avatars/Avatar$avatarId.png';
    });
  }

  void _openAvatarDialog() async {
    final selectedAvatar = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir un avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, avatars[index]);
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatars[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedAvatar != null) {
      setState(() {
        avatarPath = selectedAvatar;
      });
      ApiManager().updateAvatar(avatars.indexOf(selectedAvatar) + 1);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.user.username,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: titreColor),
          ),
        ),
        backgroundColor: primary,
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
                              radius: 80,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(avatarPath),
                            ),
                          const SizedBox(height: 18),
                          TextButton(
                            onPressed: () { _openAvatarDialog();},
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

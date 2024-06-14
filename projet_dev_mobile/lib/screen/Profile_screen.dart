import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Change_page.dart';
import '../services/api.dart';
import '../widget/TextField.dart';
import '../widget/VoyageField.dart';
import '../variables/colors.dart';
import 'package:projet_dev_mobile/screen/home_screen.dart';
import 'package:projet_dev_mobile/variables/icons.dart';
import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String password = '';
  String confirmPassword = '';
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

  String errorMessage = '';
  String successMessage = '';

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

  void _updateUser() async {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    final apiManager = ApiManager();
    bool usernameChanged = username.isNotEmpty && username != widget.user.username;
    bool passwordChanged = password.isNotEmpty && password == confirmPassword;

    try {
      if (usernameChanged && passwordChanged) {
        await apiManager.updateAll(username, password);
      } else if (usernameChanged) {
        await apiManager.updateUsername(username);
      } else if (passwordChanged) {
        await apiManager.updatePassword(password);
      }

      if (usernameChanged || passwordChanged) {
        setState(() {
          successMessage = 'Mise à jour réussie!';
        });
        NavigateAfterDelay(() => LoginScreen(), 5, context);
      } else {
        setState(() {
          errorMessage = 'Aucune modification apportée.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Stack(
          children: [
            Center(
              child: Text(
                widget.user.username,
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
                              child: buildTextField(
                                'Nouveau nom d\'utilisateur',
                                onChanged: (newValue) {
                                  username = newValue;
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Nouveau mot de passe', obscureText: true, onChanged: (newValue) {password = newValue;}),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: buildTextField('Confirmer mot de passe', obscureText: true, onChanged: (newValue) {confirmPassword = newValue;}),
                            ),
                            if (errorMessage.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(errorMessage, style: const TextStyle(color: deleteColor, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                            if (successMessage.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(successMessage, style: const TextStyle(color: acceptColor, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
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
                        const SizedBox(width: 20),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {_updateUser();},
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

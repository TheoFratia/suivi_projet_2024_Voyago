import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/screen/Profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../variables/colors.dart';
import '../../variables/profile_option.dart';
import '../../services/api.dart';
import '../screen/login_screen.dart';

class PopupButton extends StatefulWidget {
  const PopupButton({super.key});

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton> {
  late User? user;
  String username = ProfileOption.profile.value;

  int? avatarId;
  String? avatarPath;

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    user =  await ApiManager().fetchUser();
    if (user != null) {
      _loadAvatar();
      setState(() {
        username = user!.username;
      });
    }
  }

  void _loadAvatar() async {
    final preferences = await SharedPreferences.getInstance();
    avatarId = preferences.getInt('avatarId') ?? 1;
    setState(() {
      avatarPath = 'assets/avatars/Avatar$avatarId.png';
    });
  }

  void _logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: inputColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 5,
          ),
        ],
      ),
      child: PopupMenuButton(
        itemBuilder: (BuildContext context) {
          final List<PopupMenuEntry<Object>> items = [
            PopupMenuItem(
              value: username,
              child: Text(username),
            ),
          ];

          if (user != null) {
            items.add(
              PopupMenuItem(
                value: ProfileOption.deconnexion,
                child: Text(ProfileOption.deconnexion.value),
              ),
            );
          }

          return items;
        },
        onSelected: (value) {
          if (value == ProfileOption.deconnexion) {
            _logout();
          } else if (value == ProfileOption.profile.value){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage( user: user!)));
          }
        },
        child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: avatarPath != null ? AssetImage(avatarPath!) : null,
            child: avatarPath == null ? const Icon(
              Icons.account_circle,
              size: 36,
            ) : null,
          ),
      ),
    );
  }
}
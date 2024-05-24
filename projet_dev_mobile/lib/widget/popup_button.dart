import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/profile_option.dart';
import '../../services/api.dart';
import '../screen/login_screen.dart';


class PopupButton extends StatefulWidget {
  const PopupButton({Key? key}) : super(key: key);

  @override
  State<PopupButton> createState() => _PopupButtonState();
}



class _PopupButtonState extends State<PopupButton> {
  late User? user;
  String username = ProfileOption.Profile.value;


  @override
  void initState(){
    super.initState();
    _loadUser();
  }


  void _loadUser() async {
    user =  await ApiManager().fetchUser();
    if (user != null) {
      setState(() {
        username = user!.username;
      });
    }
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
          return [
            PopupMenuItem(
              value: username,
              child: Text(username),
            ),
            PopupMenuItem(
              value: ProfileOption.Deconnexion,
              child: Text(ProfileOption.Deconnexion.value),
            ),
          ];
        },
        onSelected: (value) {
          if (value == ProfileOption.Deconnexion) {
            _logout();
          }else if (value == ProfileOption.Profile.value){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          }else {
            print("aller sur la page de profile");
          }
        },
        child: const Icon(iconProfile),
      ),
    );
  }
}

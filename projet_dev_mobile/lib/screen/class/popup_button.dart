import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../variables/colors.dart';
import '../../variables/profile_option.dart';


class PopupButton extends StatelessWidget {
  const PopupButton({Key? key}) : super(key: key);

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
            const PopupMenuItem(
              child: Text('Profile'),
              value: ProfileOption.Profile,
            ),
            const PopupMenuItem(
              child: Text('Déconnexion'),
              value: ProfileOption.Deconnexion,
            ),
          ];
        },
        onSelected: (value) {
          print(value);
        },
        child: const Icon(Icons.more_vert),
      ),
    );
  }
}

import 'package:flutter/material.dart';



class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premier champ de texte
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Entrez votre nom',
                        ),
                      ),
                    ),
                    // Bouton
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
                // Deuxième champ de texte
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Entrez votre email',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
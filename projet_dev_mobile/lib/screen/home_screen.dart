import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../variables/colors.dart';
import '../variables/icons.dart';
import 'information_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String destination;
  Color borderColor = borderColorHome;
  List<String> listLieux = [];

  bool estPresentDansListe(String recherche, List<String> liste) {
    final rechercheNormalisee = _normaliser(recherche.toLowerCase());
    final listeNormalisee =
    liste.map((element) => _normaliser(element.toLowerCase()));
    return listeNormalisee.contains(rechercheNormalisee);
  }

  String _normaliser(String input) {
    return input.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  void searchDestination() {
    if (estPresentDansListe(destination, listLieux)) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => InformationPage(destination: destination, userId: 335, geoId: 1745,),));
    }
    else {
      setState(() {
        borderColor = errorBorderColor;
      });
    }
  }

  void selectRandomDestination() {
    setState(() {
      destination = listLieux[Random().nextInt(listLieux.length)];
    });
    searchDestination();
  }

  @override
  void initState() {
    super.initState();
    ApiManager().loadData(context).then((data) {
      setState(() {
        listLieux = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.7,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    child: Image.asset('assets/images/logo.png')),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: inputColor,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            color: borderColor,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: shadow,
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return listLieux.where((String item) {
                              return item
                                  .toLowerCase()
                                  .contains(textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            destination = selection;
                          },
                          fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                              ) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onFieldSubmitted: (String value) {},
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 10, bottom: 10),
                                  icon: const Icon(iconSearchInput),
                                  onPressed: () {
                                    searchDestination();
                                  },
                                ),
                                filled: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Quel est votre destination ?',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 40.0),
                              ),
                              onChanged: (value) {
                                destination = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: selectRandomDestination,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: iconColor,
                          backgroundColor: inputColor,
                          padding: const EdgeInsets.symmetric(horizontal: -20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Icon(iconRandom),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 160),
                child: SizedBox(
                  width: 210,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(90),
                      boxShadow: [
                        BoxShadow(
                          color: shadow,
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        hintText: 'Un budget ?',
                      ),
                      keyboardType: TextInputType.number,
                    ),
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

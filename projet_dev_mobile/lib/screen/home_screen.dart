import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_dev_mobile/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'information_screen.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<String> listLieux = [];
  late String destination;
  SharedPreferences? preferences;

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences?.getString('token');
    final uri = Uri.parse('http://10.70.3.216:8000/api/geo');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token',},);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> countries = data['countries'];
      List<dynamic> cities = data['cities'];
      listLieux = [...countries, ...cities];
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
  }


  void searchDestination() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Information(destination: destination),));
  }

  @override
  void initState() {
    loadData();
    super.initState();
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
                        child: Image.asset('assets/images/logo.png'))
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7), // Shadow color
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
                                return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              destination = selection;
                            },
                            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (String value) {
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      searchDestination();
                                    },
                                  ),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(90),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Quel est votre destination ?',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                                ),
                                onChanged: (value) {
                                  destination = value;
                                },
                              );
                            },
                          )
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: -20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Button border radius
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.casino_outlined),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(90),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent, // Utiliser une couleur transparente pour l'arrière-plan du TextField
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
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
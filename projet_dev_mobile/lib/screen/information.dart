import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class Information extends StatefulWidget {
  final String destination;
  const Information({super.key, required this.destination});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  SharedPreferences? preferences;
  String selectedOption = 'Infos utiles';
  List<dynamic> filteredActivities = [];
  List<dynamic> filteredHotels = [];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences?.getString('token');
    final uri = Uri.parse('http://10.70.3.216:8000/api/geo/${widget.destination}');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> activities = [];
      List<dynamic> hotels = [];

      for (var item in data) {
        List<dynamic> pointOfInterests = item['pointOfInterests'];
        for (var poi in pointOfInterests) {
          List<dynamic> idIType = poi['idIType'];
          for (var idType in idIType) {
            if (idType['type'] == 'activity') {
              activities.add(poi);
              break;
            } else if (idType['type'] == 'hostel') {
              hotels.add(poi);
              break;
            }
          }
        }
      }

      setState(() {
        selectedOption = 'Activités';
        filteredActivities = activities;
        filteredHotels = hotels;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(130, 205, 249, 1),
        child: SafeArea(
          child: Column(
            children: [
              Row(
              children: [
                Expanded(child: Text(
                  widget.destination,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),],),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Infos utiles';
                          });
                        },
                        child: Text(
                          "Infos utiles",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption == 'Infos utiles'
                                ? const Color.fromRGBO(255, 227, 97, 1)
                                : const Color.fromRGBO(130, 206, 249, 1.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Activités';
                          });
                        },
                        child: Text(
                          "Activités",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption == 'Activités'
                                ? const Color.fromRGBO(255, 227, 97, 1)
                                : const Color.fromRGBO(130, 206, 249, 1.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Hôtels';
                          });
                        },
                        child: Text(
                          "Hôtels",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption == 'Hôtels'
                                ? const Color.fromRGBO(255, 227, 97, 1)
                                : const Color.fromRGBO(130, 206, 249, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedOption == 'Activités')
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              activity['price'] != null
                                  ? '€${activity['price']}'
                                  : '',
                              style: const TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final url = activity['link'];
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Voir plus',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(activity['description'] ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (selectedOption == 'Hôtels')
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              hotel['price'] != null
                                  ? '€${hotel['price']}'
                                  : '',
                              style: const TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final url = hotel['link'];
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Voir plus',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(hotel['description'] ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

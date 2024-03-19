import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class Information extends StatefulWidget {
  final String destination;
  const Information({super.key, required this.destination});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  SharedPreferences? preferences;
  String selectedOption = 'Activités';
  List<dynamic> filteredActivities = [];
  List<dynamic> filteredHotels = [];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences?.getString('token');
    final uri = Uri.parse('http://192.168.1.66:8000/api/geo/${widget.destination}');
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
          print(poi['images']);
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()),
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
                  Expanded(
                    child: Text(widget.destination,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                height: 50,
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
                                : const Color.fromRGBO(130, 205, 249, 1),
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
                                : const Color.fromRGBO(130, 205, 249, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedOption == 'Activités')
                Expanded(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: filteredActivities.map<Widget>((activity) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 5,
                        height: 400,
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          activity['titre'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          activity['description'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          activity['price'] != null ? '€${activity['price']}' : '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final url = activity['link'];
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromRGBO(130, 205, 249, 1),
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(MediaQuery.of(context).size.width / 2 - 15, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (selectedOption == 'Hôtels')
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: filteredHotels.map<Widget>((hotel) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 -5,
                          height: 400,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            hotel['titre'] ?? '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            hotel['description'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            hotel['price'] != null ? '€${hotel['price']}' : '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final url = hotel['link'];
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromRGBO(130, 205, 249, 1),
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(MediaQuery.of(context).size.width / 2 - 15, 40),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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

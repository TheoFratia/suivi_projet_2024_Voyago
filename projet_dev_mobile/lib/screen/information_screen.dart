import 'package:flutter/material.dart';
import '../Widget/popup_button.dart';
import '../models/PointOfInterest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api.dart';
import '../variables/colors.dart';
import '../variables/informationOption.dart';

class Information extends StatefulWidget {
  final String destination;
  final int userId;
  final int geoId;
  const Information({super.key, required this.destination, required this.userId, required this.geoId});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  SharedPreferences? preferences;
  String selectedOption = InformationOption.activities.value;
  List<PointOfInterest> filteredActivities = [];
  List<PointOfInterest> filteredHotels = [];
  Set<String> savedItems = {};

  @override
  void initState() {
    super.initState();
    fetchInformationData();
    loadSavedItems();
  }

  Future<void> fetchInformationData() async {
    final data = await ApiManager().loadInformationData(context, widget.destination);
    setState(() {
      filteredActivities = data.where((geo) => geo.pointOfInterest != null).expand((geo) => geo.pointOfInterest!.pointOfInterests).where((poi) => poi.type == 'activity').toList();
      filteredHotels = data.where((geo) => geo.pointOfInterest != null).expand((geo) => geo.pointOfInterest!.pointOfInterests).where((poi) => poi.type == 'hostel').toList();
    });
  }

  Future<void> loadSavedItems() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      savedItems = preferences?.getStringList('savedItems')?.toSet() ?? {};
    });
  }

  Future<void> toggleSaveItem(int poi) async {
    List<int> savedItemsList = [];
    setState(() {
      if (savedItems.contains(poi.toString())) {
        savedItems.remove(poi.toString());
      } else {
        savedItems.add(poi.toString());
      }
    });
    await preferences?.setStringList('savedItems', savedItems.toList());

    savedItemsList.add(poi);
    try {
      if (savedItems.contains(poi.toString())) {
        await ApiManager().saveFavorites(context, savedItemsList, widget.geoId, widget.userId);
      } else {
        await ApiManager().deleteFavorites(context, poi, widget.userId);
      }
    } catch (e) {
      print('Failed to save favorites: $e');
    }
  }

  Widget buildCard(PointOfInterest item, bool isActivity) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 5,
      height: 500,
      child: Card(
        color: cardColor,
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
                  item.imageLink,
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
                        item.titre,
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
                        item.description,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${item.price}€',
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
                          final url = item.link;
                          if (await canLaunchUrl(url as Uri)) {
                            await launchUrl(url as Uri);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: informationButtonBackgroudColor,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(MediaQuery.of(context).size.width / 2 - 15, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Book Now', style: TextStyle(color: informationButtonTextColor)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        savedItems.contains(item.id.toString()) ? Icons.favorite : Icons.favorite_border,
                        color: savedItems.contains(item.id.toString()) ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        toggleSaveItem(item.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.destination,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: titreColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 5),
                    child: const PopupButton(),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                height: 50,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: inputColor,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = InformationOption.activities.value;
                          });
                        },
                        child: Text(
                          "Activités",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption == InformationOption.activities.value
                                ? selectedTextColor
                                : notSelectedTextColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = InformationOption.hotel.value;
                          });
                        },
                        child: Text(
                          "Hôtels",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption == InformationOption.hotel.value
                                ? selectedTextColor
                                : notSelectedTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedOption == InformationOption.activities.value)
                Expanded(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: filteredActivities.map<Widget>((activity) {
                      return buildCard(activity, true);
                    }).toList(),
                  ),
                ),
              if (selectedOption == InformationOption.hotel.value)
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: filteredHotels.map<Widget>((hotel) {
                        return buildCard(hotel, false);
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
import 'package:flutter/material.dart';
import '../Widget/popup_button.dart';
import '../models/PointOfInterest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api.dart';
import '../variables/colors.dart';
import '../variables/informationOption.dart';
import 'package:projet_dev_mobile/screen/home_screen.dart';
import 'package:projet_dev_mobile/variables/icons.dart';
import 'package:projet_dev_mobile/variables/colors.dart';

class Information extends StatefulWidget {
  final String destination;
  const Information({super.key, required this.destination});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  SharedPreferences? preferences;
  String selectedOption = InformationOption.activities.value;
  List<PointOfInterest> filteredActivities = [];
  List<PointOfInterest> filteredHotels = [];

  Future<void> fetchInformationData() async {
    final data = await ApiManager().loadInformationData(context, widget.destination);
    setState(() {
      filteredActivities = data.where((geo) => geo.pointOfInterest != null).expand((geo) => geo.pointOfInterest!.pointOfInterests).where((poi) => poi.type == 'activity').toList();
      filteredHotels = data.where((geo) => geo.pointOfInterest != null).expand((geo) => geo.pointOfInterest!.pointOfInterests).where((poi) => poi.type == 'hostel').toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInformationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(iconArrow, color: arrowColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Home(),
            ));
          },
        ),
        title: Center(
          child: Text(
            widget.destination,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: titreColor,
            ),
          ),
        ),
        actions: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 5),
            child: const PopupButton(),
          ),
        ],
      ),
      body: Container(
          color: primary,
          child: SafeArea(
            child: Column(
                children: [
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
                      activity.imageLink,
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
                          child: Text(activity.titre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(activity.description,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text( '${activity.price}€',
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
                              final url = Uri.parse(activity.link); // Conversion en Uri
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
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
    if (selectedOption == InformationOption.hotel.value)
    Expanded(
    child: SingleChildScrollView(
    child: Wrap(
    spacing: 10.0,
    runSpacing: 10.0,
    children: filteredHotels.map<Widget>((hotel) {
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
    hotel.imageLink,
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
    child: Text(hotel.titre,
    textAlign: TextAlign.center,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(hotel.description,
    style: const TextStyle(
    fontSize: 12,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text('${hotel.price}€',
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
    final url = Uri.parse(hotel.link); // Conversion en Uri
    if (await canLaunchUrl(url)) {
    await launchUrl(url);
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

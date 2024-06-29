import 'package:flutter/material.dart';
import 'package:projet_dev_mobile/models/user.dart';
import 'package:projet_dev_mobile/variables/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widget/popup_button.dart';
import '../models/EssentialInformation.dart';
import '../models/ImportantInformation.dart';
import '../models/PointOfInterest.dart';
import '../services/api.dart';
import '../variables/colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

enum InformationOption {
  activities,
  hotel,
  important,
  essential,
}

class InformationPage extends StatefulWidget {
  final String destination;
  final bool? justFav;

  const InformationPage({
    super.key,
    required this.destination,
    this.justFav
  });

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String selectedOption = InformationOption.activities.toString();
  List<PointOfInterest> filteredActivities = [];
  List<PointOfInterest> filteredHotels = [];
  List<ImportantInformation> importantInformation = [];
  List<EssentialInformation> essentialInformation = [];
  Set<String> savedItems = {};
  SharedPreferences? preferences;
  late User? user;

  @override
  void initState() {
    super.initState();
    fetchInformationData();
    fetchImportantInformation();
    fetchEssentialInformation();
    _loadUser();
  }

  void _loadUser() async {
    user =  await ApiManager().fetchUser();
    if (user != null) {
      loadSavedItems();
    }
  }

  Future<void> fetchInformationData() async {
    final data =
        await ApiManager().loadInformationData(context, widget.destination);
    setState(() {
      filteredActivities = data
          .where((geo) => geo.pointOfInterest != null)
          .expand((geo) => geo.pointOfInterest!.pointOfInterests)
          .where((poi) => poi.type == 'activity')
          .toList();
      filteredHotels = data
          .where((geo) => geo.pointOfInterest != null)
          .expand((geo) => geo.pointOfInterest!.pointOfInterests)
          .where((poi) => poi.type == 'hostel')
          .toList();
    });
  }

  void filterListsByFavorites() {
    if (widget.justFav == true) {
      setState(() {
        filteredActivities = filteredActivities
            .where((activity) => savedItems.contains(activity.id.toString()))
            .toList();
        filteredHotels = filteredHotels
            .where((hotel) => savedItems.contains(hotel.id.toString()))
            .toList();
      });
    }
  }

  Future<void> fetchImportantInformation() async {
    final infoData = await ApiManager().getAllImportantInformation();
    setState(() {
      importantInformation = infoData
          .where((info) => info['idGeo'].any((geo) =>
              geo['city'] == widget.destination ||
              geo['country'] == widget.destination))
          .map((info) => ImportantInformation.fromJson(info))
          .toList();
    });
  }

  Future<void> fetchEssentialInformation() async {
    final infoData = await ApiManager().getAllEssentialInformation();
    setState(() {
      essentialInformation = infoData
          .where((info) => info['idGeo'].any((geo) =>
              geo['city'] == widget.destination ||
              geo['country'] == widget.destination))
          .map((info) => EssentialInformation.fromJson(info))
          .toList();
    });
  }

  Future<void> loadSavedItems() async {
    savedItems = await ApiManager().loadFavorites(context, widget.destination, user!.uuid);
    setState(() {
      savedItems = savedItems.toSet();
      filterListsByFavorites();
    });
  }

  Future<void> toggleSaveItem(String itemId) async {
    try {
      if (!savedItems.contains(itemId) && user != null) {
        await ApiManager().saveFavorites(context, [int.parse(itemId)], user!.uuid, widget.destination);
      } else if (user != null) {
        await ApiManager().deleteFavorites(context, int.parse(itemId), user!.uuid);
      }
      else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      setState(() {
        if (savedItems.contains(itemId)) {
          savedItems.remove(itemId);
        } else {
          savedItems.add(itemId);
        }
      });
    } catch (e) {
      throw Exception('Failed to save item');
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
              height: 200,
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
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 2 - 15, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Book Now',
                            style:
                                TextStyle(color: informationButtonTextColor)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        savedItems.contains(item.id.toString())
                            ? iconSelectedHeart
                            : iconHeart,
                        color: savedItems.contains(item.id.toString())
                            ? heartSelectColor
                            : heartColor,
                      ),
                      onPressed: () {
                        toggleSaveItem(item.id.toString());
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
                  color: cardColor,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption =
                                InformationOption.activities.toString();
                          });
                        },
                        child: Text(
                          "Activités",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption ==
                                    InformationOption.activities.toString()
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
                            selectedOption = InformationOption.hotel.toString();
                          });
                        },
                        child: Text(
                          "Hôtels",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption ==
                                    InformationOption.hotel.toString()
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
                            selectedOption =
                                InformationOption.important.toString();
                          });
                        },
                        child: Text(
                          "Informations importantes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption ==
                                    InformationOption.important.toString()
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
                            selectedOption =
                                InformationOption.essential.toString();
                          });
                        },
                        child: Text(
                          "Indispensables",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedOption ==
                                    InformationOption.essential.toString()
                                ? selectedTextColor
                                : notSelectedTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (selectedOption ==
                          InformationOption.activities.toString())
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: filteredActivities.map<Widget>((activity) {
                            return buildCard(activity, true);
                          }).toList(),
                        ),
                      if (selectedOption == InformationOption.hotel.toString())
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: filteredHotels.map<Widget>((hotel) {
                            return buildCard(hotel, false);
                          }).toList(),
                        ),
                      if (selectedOption ==
                          InformationOption.important.toString())
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: importantInformation.map<Widget>((info) {
                            return buildInformationCard(info);
                          }).toList(),
                        ),
                      if (selectedOption ==
                          InformationOption.essential.toString())
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: essentialInformation.map<Widget>((info) {
                            return buildInformationCard(info);
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInformationCard(dynamic info) {
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
              height: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  info.imageLink,
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
                        info.titre,
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
                        info.description,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
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
  }
}

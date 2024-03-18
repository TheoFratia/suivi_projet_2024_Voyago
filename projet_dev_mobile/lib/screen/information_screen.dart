import 'dart:convert';

import 'package:flutter/material.dart';
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

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences?.getString('token');
    final uri = Uri.parse('http://10.70.3.216:8000/api/geo/${widget.destination}');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token',},);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Container(color: const Color.fromRGBO(130, 205, 249, 1),
      child: SafeArea(child:Column(children: [
        Row(children: [
          const SizedBox( width: 50),
          Expanded(child: Text(widget.destination, textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),),
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))],),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          height: 60,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
          ),
          child: const Row(
          children: [
            Expanded(child: Text("Infos utiles", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 227, 97, 1)),),),
            Expanded(child: Text("Activités", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(130, 205, 249, 1))),),
            Expanded(child: Text("Hôtels", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(130, 205, 249, 1))),),
          ],
        ),)
      ],)
      ),
      ),
    );
  }
}

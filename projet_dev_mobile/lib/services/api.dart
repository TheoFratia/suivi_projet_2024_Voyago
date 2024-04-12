import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/geo.dart';
import '../screen/login_screen.dart';

class ApiManager {
  final String baseUrl = 'http://10.70.3.216:8000/api';

  Future<List<String>> loadData(BuildContext context) async {
    var preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final uri = Uri.parse('$baseUrl/geo');
    try {
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> countries = data['countries'];
        List<dynamic> cities = data['cities'];
        return [...countries, ...cities].cast<String>();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
        return [];
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      return [];
    }
  }


  login(String name, String password) async {
    final bodyContent = jsonEncode({'username': name, 'password': password,});

    final response = await http.post(Uri.parse('$baseUrl/login_check'), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = json.decode(response.body);
      final preferences = await SharedPreferences.getInstance();
      preferences.setString('token', user['token']);
      return null; // Indicate successful login (replace with appropriate action)
    } else if (response.statusCode == 401){
      return 'Nom d\'utilisateur ou mot de passe incorrect';
    }else {
      final errorJson = response.body;
      final Map<String, dynamic> errorMap = json.decode(errorJson);

      final String errorMessage = errorMap['message'] ?? 'Login failed';

      return errorMessage; // Return the error message
    }
  }

  createUser(String name, String password) async {
    const String apiUrl = 'http://10.70.3.216:8000/api/user';
    final bodyContent = jsonEncode({'username': name, 'password': password,});

    final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

    if (response.statusCode == 201) {
      return null;
    }else {
      final errorJson = response.body;
      final Map<String, dynamic> errorMap = json.decode(errorJson);

      final String errorMessage = errorMap['message'];

      return errorMessage; // Return the error message
    }
  }



  Future<List<Geo>> loadInformationData(BuildContext context, String destination) async {
    var preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final uri = Uri.parse('$baseUrl/geo/$destination');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      List<Geo> geoData = [];

      final data = json.decode(response.body) as List;
      for (var item in data) {
        Geo geo = Geo.fromJson(item);
        geoData.add(geo);
      }
      return geoData;
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return []; // Return an empty list on error
    }
  }

}
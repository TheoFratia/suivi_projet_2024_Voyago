import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/geo.dart';
import '../models/user.dart';
import '../screen/login_screen.dart';
import '../models/location.dart';

class ApiManager {
  final String _baseUrl = 'http://192.168.1.66:8000/api';

  Future<List<String>> loadData(BuildContext context) async {
    final uri = Uri.parse('$_baseUrl/geo');
    try {
      final response = await http.get(uri);
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

    final response = await http.post(Uri.parse('$_baseUrl/login_check'), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = json.decode(response.body);
      final preferences = await SharedPreferences.getInstance();
      preferences.setString('token', user['token']);
      return null;
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
    final String apiUrl = '$_baseUrl/api/user';
    final bodyContent = jsonEncode({'username': name, 'password': password,});

    final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

    if (response.statusCode == 201) {
      return null;
    }else {
      final errorJson = response.body;
      final Map<String, dynamic> errorMap = json.decode(errorJson);

      final String errorMessage = errorMap['message'];

      return errorMessage;
    }
  }



  Future<List<Geo>> loadInformationData(BuildContext context, String destination) async {
    final uri = Uri.parse('$_baseUrl/geo/$destination');
    final response = await http.get(uri);

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
      return [];
    }
  }

  Future<User?> fetchUser() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token') ?? '';
    final uri = Uri.parse('$_baseUrl/user');

    try {
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token',});
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return await fetchUserByUuid(userData['id'], token, userData['avatarId']);
      } else{
        return null;
      }
    } catch (e) {
      return null;
    }
  }



  Future<User?> fetchUserByUuid(String uuid, String token, int avatarId) async {
    final uri = Uri.parse('$_baseUrl/user/$uuid');
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token',});

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final preferences = await SharedPreferences.getInstance();
        preferences.setString('uuid', uuid);
        preferences.setInt('avatarId', avatarId);
        return User.fromJson(userData);
      } else {
        return null;
      }
  }

  Future<List<dynamic>> getAllImportantInformation() async {
    final response = await http.get(Uri.parse('$_baseUrl/info'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load important information');
    }
  }

  Future<List<dynamic>> getAllEssentialInformation() async {
    final response = await http.get(Uri.parse('$_baseUrl/essential'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load essential information');
    }
  }

  Future<void> updateAvatar(int avatarId) async {
    final preferences = await SharedPreferences.getInstance();
    String uuid = await preferences.getString('uuid') ?? '';
    String token = preferences.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/user/$uuid');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'avatarId': avatarId,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      preferences.setInt('avatarId', avatarId);
    } else {
      throw Exception('Failed to update avatar');
    }
  }

  Future<void> updateUsername(String username) async {
    final preferences = await SharedPreferences.getInstance();
    String uuid = preferences.getString('uuid') ?? '';
    String token = preferences.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/user/$uuid');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'username': username});

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Impossible de mettre à jour votre nom d\'utilisateur !');
    }
  }

  Future<void> updatePassword(String password) async {
    final preferences = await SharedPreferences.getInstance();
    String uuid = preferences.getString('uuid') ?? '';
    String token = preferences.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/user/$uuid');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'password': password});

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Impossible de mettre à jour votre mot de passe !');
    }
  }

  Future<void> updateAll(String username, String password) async {
    final preferences = await SharedPreferences.getInstance();
    String uuid = preferences.getString('uuid') ?? '';
    String token = preferences.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/user/$uuid');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('impossible de mettre vos identifiants !');
    }
  }

  Future<void> saveFavorites(BuildContext context, List<int> pointOfInterestIds, String userUuid, String name) async {
    final String apiUrl = '$_baseUrl/save';
    String token = (await SharedPreferences.getInstance()).getString('token') ?? '';
    final bodyContent = jsonEncode({
      'idPointOfInterest': pointOfInterestIds.map((id) => {'id': id}).toList(),
      'name': name,
      'uuid': userUuid
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: bodyContent,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> deleteFavorites(BuildContext context, int pointOfInterestIds, String userUuid) async {
    final String apiUrl = '$_baseUrl/save';
    String token = (await SharedPreferences.getInstance()).getString('token') ?? '';
    final bodyContent = jsonEncode({
      'idPointOfInterest': pointOfInterestIds,
      "force": true,
      'uuid': userUuid
    });

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: bodyContent,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<Set<String>> loadFavorites(BuildContext context, String name, String uuid) async {
    Set<String> idPointOfInterest = {};
    final String apiUrl = '$_baseUrl/saves/$uuid/$name';
    String token = (await SharedPreferences.getInstance()).getString('token') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      var data = jsonDecode(response.body) as List;
      for (var item in data) {
        var idPointOfInterestList = item['idPointOfInterest'] as List;
        for (var id in idPointOfInterestList) {
          idPointOfInterest.add(id['id'].toString());
        }
      }
    }
    return idPointOfInterest;
  }

  Future<List<Location>> loadMyFavorites(BuildContext context, String uuid) async {
    final String apiUrl = '$_baseUrl/saves/$uuid';
    String token = (await SharedPreferences.getInstance()).getString('token') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return [];
    } else {
      var data = jsonDecode(response.body) as List;
      List<Location> locations = data.map((item) => Location.fromJson(item)).toList();
      return locations;
    }
  }
}

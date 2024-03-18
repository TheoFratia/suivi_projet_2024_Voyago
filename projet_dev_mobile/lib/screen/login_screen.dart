import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:projet_dev_mobile/screen/home.dart';
import 'package:http/http.dart' as http;
import "package:shared_preferences/shared_preferences.dart";


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});


  Duration get loginTime => const Duration(milliseconds: 2250);

  final ThemeData _theme = ThemeData(
    primaryColor: const Color.fromRGBO(92, 175, 231, 1.0),
  );

  login(String name, String password) async {
    const String apiUrl = 'http://10.70.3.216:8000/api/login_check';
    final bodyContent = jsonEncode({'username': name, 'password': password,});

    final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

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


  Future<String?> _authUser(LoginData data) async {
    return Future.delayed(loginTime).then((_) async {
      return await login(data.name, data.password);
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) async {
      if (data.name == null || data.password == null) {
        return 'Veuillez remplir tous les champs';
      }
      final name = data.name;
      final password = data.password;
      final user = await createUser(name!, password!);
      if (user == null){
        return await login(name, password);
      }else{
        return "Erreur lors de la création de l'utilisateur";
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return 'Password recovery not yet implemented';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      home: FlutterLogin(
        logo: const AssetImage('assets/images/logo.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        },
        onRecoverPassword: _recoverPassword,
        messages: LoginMessages(
          userHint: 'Username',
          passwordHint: 'Password',
        ),
        userType: LoginUserType.name,
        hideForgotPasswordButton: true,
        userValidator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le nom d\'utilisateur ne peut pas être vide';
          }
          return null;
        },
        passwordValidator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le mot de passe ne peut pas être vide';
          }
          return null;
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:projet_dev_mobile/screen/home.dart';
import 'package:http/http.dart' as http;
import "package:shared_preferences/shared_preferences.dart";

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  SharedPreferences? preferences;

  Duration get loginTime => const Duration(milliseconds: 2250);

  final ThemeData _theme = ThemeData(
    primaryColor: Color.fromRGBO(92, 175, 231, 1.0),
  );

  Future<String?> _authUser(LoginData data) async {
    final String apiUrl = 'http://192.168.1.66:8000/api/login_check';
    final bodyContent = jsonEncode({'username': data.name, 'password': data.password,});

    final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'},  body: bodyContent,);

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = json.decode(response.body);
      preferences = await SharedPreferences.getInstance();
      preferences?.setString('token', user['token']);
      return null; // Indicate successful login (replace with appropriate action)
    } else if (response.statusCode == 401){
      return 'Nom d\'utilisateur ou mot de passe incorrect';
    }else {
      final errorJson = await response.body;
      final Map<String, dynamic> errorMap = json.decode(errorJson);

      final String errorMessage = errorMap['message'] ?? 'Login failed';

      return errorMessage; // Return the error message
    }
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
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
            builder: (context) => Home(),
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

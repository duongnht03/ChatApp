import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/models/login_param.dart';
import 'package:chatapp/models/login_res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  void _login() async {
    LoginParam param = LoginParam(email: _email.text, password: _password.text);
    final response = await http.post(
      Uri.parse("http://192.168.56.1:8080/api/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(param.toJson()),
    );
    LoginModel data = LoginModel.fromJson(json.decode(response.body));

    print(data.user?.id);
    if (data.accessToken != null) {
      Navigator.pushNamed(
          context, '/products');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data.accessToken.toString());
      print(prefs.getString('token'));
    } else {
      print("Invalid token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 300),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter an username'),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter an password'),
              ),
              SizedBox(height: 24),
              InkWell(
                onTap: () {
                  _login();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Products()));
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      border: Border.all(width: 8),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Sign In",
                  ),
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      '/registerScreen');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  decoration: BoxDecoration(),
                  child: Text("Create an account"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
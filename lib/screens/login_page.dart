import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/models/login_param.dart';
import 'package:chatapp/models/login_res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/models/user_provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  void _login() async {
    // Tạo LoginParam và gửi yêu cầu đăng nhập tới backend
    LoginParam param = LoginParam(email: _email.text, password: _password.text);
    final response = await http.post(
      Uri.parse("http://192.168.1.91:8080/api/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(param.toJson()),
    );

    // Chuyển đổi response từ backend thành đối tượng LoginModel
    LoginModel data = LoginModel.fromJson(json.decode(response.body));

    // In ra userId từ dữ liệu nhận được

    // Kiểm tra nếu accessToken không null
    if (data.accessToken != null) {
      User user = User(
        id: data.user?.id ?? null,
        name: data.user?.name ?? '',
        email: data.user?.email ?? '',
        // thông tin provider cho user
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      Navigator.pushNamed(context, '/chats');

      // Lưu accessToken vào SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data.accessToken.toString());
      // print(prefs.getString('token'));

      // Lưu thông tin người dùng vào Firestore
      try {
        await FirebaseFirestore.instance.collection('Users').doc(data.user?.id.toString()).set({
          'accessToken': data.accessToken,
          'userId': data.user?.id,
          'name': data.user?.name,
        }, SetOptions(merge: true));
        
      } catch (e) {
        print("Error saving user informatioNn to Firestore: $e");
      }
    } else {
      print("Invalid token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_circle_left_outlined),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                    'Login to ChatBox'
                ),
                SizedBox(height: 20),
                Text('Welcome back! Sign in using your email'),
                Text('to continue us'),
                SizedBox(height: 30),
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
                SizedBox(height: 200),
                InkWell(
                  onTap: () {
                    _login();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const ChatList()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
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
      ),
    );
  }
}

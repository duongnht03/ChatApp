import 'package:flutter/material.dart';
import 'package:chatapp/screens/login_page.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({ super.key });

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context,
          '/loginScreen'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/image/Logo -uihut.png'),
      ),
    );
  }
}
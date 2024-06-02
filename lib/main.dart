import 'package:chatapp/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/splash.dart';
import 'package:chatapp/screens/login_page.dart';
import 'dart:io';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  HttpOverrides.global = CustomHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // accept when SSL certificate error
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
import 'package:flutter/material.dart';
import 'package:chatapp/screens/create_account.dart';
import 'package:chatapp/screens/splash.dart';
import 'package:chatapp/screens/login_page.dart';
import 'package:chatapp/screens/chat_list.dart';
import 'package:chatapp/screens/boxchat.dart';

class AppRouter {

  AppRouter();

  static MaterialPageRoute<Widget> onGenerateRoute(RouteSettings? settings) {
    return MaterialPageRoute<Widget>(
      settings: settings,
      builder: (BuildContext context) => makeRoute(
        context: context,
        routeName: settings?.name ?? "",
        arguments: settings?.arguments ?? "",
      ),
    );
  }

  static Widget makeRoute({
    required BuildContext context,
    required String routeName,
    dynamic arguments,
  }) {
    switch (routeName) {
      case splash:
        return InitScreen();
      case loginScreen:
        return LoginScreen();
      case registerScreen:
        return CreateAccount();
      case chatsScreen:
        return ChatList();
      default:
        throw 'Route $routeName is not defined';
    }
  }

  static String get initRouter => splash;

  static const String splash = '/';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String chatsScreen = '/chats';
  // static const String boxchat = '/boxchat';
}
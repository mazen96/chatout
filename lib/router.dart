import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/ui/views/sign_in_view.dart';
import 'package:chatout/ui/views/home_view.dart';
import 'package:chatout/ui/views/sign_up_view.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.SignIn:
        return MaterialPageRoute(builder: (_) => SignInView());
      case RoutePaths.SignUp:
        return MaterialPageRoute(builder: (_) => SignUpView());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
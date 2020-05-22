import 'package:flutter/material.dart';

// this service is used when you need to navigate inside your business logic
// where you can't get the BuildContext object so this service provide
// navigation without context using navigatorKey
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> pushReplacementNamed(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }
}

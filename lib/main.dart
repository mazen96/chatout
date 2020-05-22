import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/provider_setup.dart';
import 'package:chatout/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/navigation_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          title: 'Chatout',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: RoutePaths.StartUp,
          onGenerateRoute: Router.generateRoute,
          navigatorKey: NavigationService.navigatorKey),
    );
  }
}

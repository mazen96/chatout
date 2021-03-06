import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:chatout/core/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices, // this is spread operator which spreads all list contents into another list
  ...dependentServices,
  ...uiConsumableProviders
];
List<SingleChildWidget> independentServices = [
  Provider.value(value: NavigationService()),
  Provider.value(value: FirestoreService())
];
List<SingleChildWidget> dependentServices = [
  ProxyProvider<FirestoreService, FireAuth>(
      update: (context, firestore, firebaseAuth) =>
          FireAuth(firestoreService: firestore)),
];
List<SingleChildWidget> uiConsumableProviders = [];

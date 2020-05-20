import 'package:chatout/core/services/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/services/api.dart';

List<SingleChildWidget> providers = [
  ...independentServices, // this is spread operator which spreads all list contents into another list
  ...dependentServices,
  ...uiConsumableProviders
];
List<SingleChildWidget> independentServices = [
  Provider.value(value: FireAuth())
];
List<SingleChildWidget> dependentServices = [];
List<SingleChildWidget> uiConsumableProviders = [];

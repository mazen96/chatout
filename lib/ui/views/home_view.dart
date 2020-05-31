import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/core/view_models/views/home_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: HomeViewModel(
          auth: Provider.of(context), firestore: Provider.of(context)),
      onModelReady: (model) => model.getMyFriends(),
      builder: (context, model, child) => Scaffold(
        appBar: buildAppBar(context, model),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutePaths.AddFriend);
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: Container(
            child: ListView.builder(
                itemCount: model.myFriends.length,
                itemBuilder: (BuildContext context, int index) {
                  print('%%%%%%%%%%%%%%%%% :: current indexxxx :: $index');
                  return ListTile(
                    title: Text(model.myFriends[index].username),
                  );
                }),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, dynamic model) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await model.signOut();
            Navigator.of(context).pushReplacementNamed(RoutePaths.SignIn);
          },
        ),
      ],
    );
  }
}

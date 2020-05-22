import 'package:chatout/core/view_models/views/startup_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        model: StartUpViewModel(
            auth: Provider.of(context), nav: Provider.of(context)),
        onModelReady: (model) => model.decideStartUpScreen(),
        builder: (context, model, child) => Scaffold(
              body: SafeArea(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
                  child: Column(
                    children: <Widget>[
                      buildHeader(context),
                      SizedBox(height: 40.0),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 5.0,
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    'Chatout',
                    style: TextStyle(
                        fontSize: 60.0,
                        fontFamily: 'Pacifico',
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

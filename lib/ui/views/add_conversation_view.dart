import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/core/view_models/views/add_conversation_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddConversationView extends StatelessWidget {
  //////////////////////////////////////////////////
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _eController = TextEditingController();
  //////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: AddConversationViewModel(
          fireAuth: Provider.of(context),
          firestoreService: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildHeader(context),
                    SizedBox(height: 20.0),
                    buildFriendEmailTextField(model),
                    SizedBox(height: 30.0),
                    model.busy
                        ? CircularProgressIndicator()
                        : buildAddButton(context, model)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 5.0,
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                child: Text(
                  'Add Friend',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Pacifico',
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////

  Widget buildFriendEmailTextField(dynamic model) {
    return TextFormField(
      controller: _eController,
      validator: (value) {
        value = value.trim();
        if (value.isEmpty) {
          return 'Please enter your friend\'s email.';
        }
        bool validEmail = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);

        if (!validEmail) {
          return 'Invalid email address.';
        }
        bool dirtyInput = value == model.currentUser.email ? true : false;
        if (dirtyInput) {
          return 'You can\'t add your self';
        }
        return null; // case :: Valid user input
      },
      decoration: InputDecoration(
        labelText: 'Friend\'s Email',
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////
  Widget buildAddButton(BuildContext context, dynamic model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            elevation: 8.0,
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () async {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                String email = _eController.text.trim();
                FocusScope.of(context).unfocus();
                ///////////////////////////////////////////
                var result = await model.addConversation(friendEmail: email);
                if (result is! bool) {
                  // Therefore result is exception
                  Alert(
                          context: context,
                          type: AlertType.error,
                          title: 'ERROR',
                          desc: '${result.message}')
                      .show();
                } else {
                  // Therefore operation is successful
                  // then we wait for return from the Alert Window
                  await Alert(
                    context: context,
                    type: AlertType.success,
                    title: 'SUCCESS',
                  ).show();

                  // navigate back to home
                  //Navigator.of(context).pushReplacementNamed(RoutePaths.Home);
                  Navigator.of(context).pop();
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Add Friend',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////

}

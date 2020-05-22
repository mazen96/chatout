import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/ui/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildHeader(context),
                SizedBox(height: 30.0),
                SignUpForm(),
                SizedBox(height: 20.0),
                buildVerticalDivider(),
                SizedBox(height: 20.0),
                buildSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
    //);
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
    );
  }

  ///////////////////////////////////////////////////////////////////////

  Widget buildVerticalDivider() {
    return Row(children: <Widget>[
      Expanded(child: Divider()),
      Text("      or      "),
      Expanded(child: Divider()),
    ]);
  }

  ////////////////////////////////////////////////////////////////////////

  Widget buildSignInButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            //color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, RoutePaths.SignIn);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Sign In To Your Account',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

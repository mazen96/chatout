import 'package:chatout/core/view_models/views/login_view_model.dart';
import 'package:chatout/ui/views/base_widget.dart';
import 'package:chatout/ui/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  var _loginSuccess = 'hiii';

  @override
  Widget build(BuildContext context) {
    //print('baseWidget:::::::::::: built');
//    return BaseWidget(
//      // no need to explicitly specify type of provider as Dart
//      // is intelligent enough for automatic type inference.
//      model: LoginViewModel(auth: Provider.of(context)),
//      builder: (context, model, _) =>
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildLoginHeader(),
                SizedBox(height: 30.0),
                LoginForm(),
                SizedBox(height: 20.0),
                buildVerticalDivider(),
                SizedBox(height: 20.0),
                buildCreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
    //);
  }

  Widget buildLoginHeader() {
    return Card(
      elevation: 5.0,
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
        child: Text(
          'Sign in',
          style: TextStyle(
              fontSize: 60.0, fontFamily: 'Pacifico', color: Colors.white),
        ),
      ),
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

  Widget buildCreateAccountButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            //color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Create Account',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

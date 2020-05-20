import 'package:chatout/core/view_models/views/login_view_model.dart';
import 'package:chatout/ui/views/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  ///////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  ///////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    print('&&&&&&&&&&&&&&&&&&&&&&& stateless rebuilt &&&&&&&&&&&&&&&&&&&');
    return BaseWidget(
      model: LoginViewModel(auth: Provider.of(context)),
      builder: (context, model, _) => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            buildEmailTextField(),
            SizedBox(height: 10.0),
            buildPasswordTextField(),
            SizedBox(height: 20.0),
            model.busy
                ? CircularProgressIndicator()
                : buildSignInButton(context, model)
          ],
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: _eController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your email.';
        }
        bool validEmail = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (!validEmail) {
          return 'Invalid email address.';
        }
        return null; // case :: Valid user input
      },
      decoration: InputDecoration(
        labelText: 'Email',
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////
  Widget buildPasswordTextField() {
    return TextFormField(
      controller: _pController,
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password.';
        }
        return null; // case :: Valid user input
      },
      decoration: InputDecoration(
        labelText: 'Password',
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////
  Widget buildSignInButton(BuildContext context, dynamic model) {
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
                String userEmail = _eController.text;
                String userPassword = _pController.text;
                _eController.clear();
                _pController.clear();
                FocusScope.of(context).unfocus();
                var result = await model.login(
                    userEmail: userEmail, userPassword: userPassword);
                if (result is! String) {
                  print('%%%%%%%%%::   ${result.message}  ::%%%%%%%%%%');
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Sign in',
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

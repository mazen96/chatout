import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/core/view_models/widgets/auth_form_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpForm extends StatelessWidget {
  ///////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uController = TextEditingController();
  final TextEditingController _eController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  ///////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: AuthFormViewModel(auth: Provider.of(context)),
      builder: (context, model, _) => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            buildUsernameTextField(),
            SizedBox(height: 10.0),
            buildEmailTextField(),
            SizedBox(height: 10.0),
            buildPasswordTextField(),
            SizedBox(height: 40.0),
            model.busy
                ? CircularProgressIndicator()
                : buildSignUpButton(context, model),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  Widget buildUsernameTextField() {
    return TextFormField(
      controller: _uController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your username.';
        }
        return null; // case :: Valid user input
      },
      decoration: InputDecoration(
        labelText: 'Username',
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
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
  Widget buildSignUpButton(BuildContext context, dynamic model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            elevation: 8.0,
            color: Theme.of(context).primaryColorLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () async {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                String username = _uController.text.trim();
                String userEmail = _eController.text.trim();
                String userPassword = _pController.text.trim();
                _uController.clear();
                _eController.clear();
                _pController.clear();
                FocusScope.of(context).unfocus();
                ///////////////////////////////////////////
                var result = await model.signUp(
                    userName: username,
                    userEmail: userEmail,
                    userPassword: userPassword);

                if (result is! String) {
                  // if result is not String (error) show Alert.
                  Alert(
                          context: context,
                          type: AlertType.error,
                          title: 'ERROR',
                          desc: '${result.message}')
                      .show();
                } else {
                  //operation is successful
                  Navigator.pushReplacementNamed(context, RoutePaths.Home);
                  //both signUp and signIn navigates to home as FireBase
                  // SignUp automatically logs in the user.
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Sign up',
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

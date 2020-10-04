import 'package:flutter/material.dart';
import 'package:jellyflut/api/auth.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/models/authenticationResponse.dart';

import 'background.dart';

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _username = "";
  String _password = "";
  var _obscureText = true;
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _MyHomePageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _username = "";
    } else {
      _username = _usernameFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _loginPressed() async {
    _username = _usernameFilter.text;
    _password = _passwordFilter.text;

    login(_username, _password).then((AuthenticationResponse response) {
      if (response == null) return null;
      Navigator.of(context).pushNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
            child: SingleChildScrollView(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: size.height * 0.15),
        Hero(
            tag: "logo",
            child: Image(
              image: AssetImage('img/jellyfin_logo.png'),
              width: 120.0,
              alignment: Alignment.center,
            )),
        SizedBox(height: size.height * 0.03),
        Hero(
          tag: "logo_text",
          child: Text(
            "Jellyfin",
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Card(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Column(
              children: [
                OutlineTextField(
                  "username",
                  controller: _usernameFilter,
                  prefixIcon: Icon(Icons.person),
                ),
                OutlineTextField(
                  'password',
                  controller: _passwordFilter,
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.vpn_key,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                GradienButton('Login', _loginPressed)
              ],
            ),
          ),
        )
      ],
    ))));
  }
}

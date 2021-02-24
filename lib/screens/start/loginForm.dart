import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/auth.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/models/userDB.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  LoginForm({this.onPressed});

  final VoidCallback onPressed;

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  String _username = '';
  String _password = '';

  _LoginFormState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _username = '';
    } else {
      _username = _usernameFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = '';
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _loginPressed() async {
    _username = _usernameFilter.text;
    _password = _passwordFilter.text;

    await login(_username, _password).then((AuthenticationResponse response) {
      if (response == null) return null;
      var db = DatabaseService();
      // Create user with info
      var userDB = UserDB();
      userDB.name = _username;
      userDB.apiKey = response.accessToken;
      apiKey = response.accessToken;

      // Insert user and server in DB
      db.insertUSer(userDB); // Save globals server object
      db.insertServer(server).then((int id) {
        SharedPreferences.getInstance()
            .then((SharedPreferences sharedPreferences) {
          sharedPreferences.setInt('serverId', id).whenComplete(
              () => Navigator.pushReplacementNamed(context, '/home'));
        });
      });
    }).catchError((onError) =>
        showToast(onError.toString(), toastLength: Toast.LENGTH_LONG));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          onPressed: widget.onPressed,
                          child: Icon(Icons.arrow_back_ios),
                        ))),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Connection',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ))),
              ],
            )),
        OutlineTextField(
          'username',
          controller: _usernameFilter,
          autofocus: false,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(passwordFocusNode),
          prefixIcon: Icon(Icons.person),
        ),
        OutlineTextField(
          'password',
          controller: _passwordFilter,
          obscureText: true,
          autofocus: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _loginPressed(),
          focusNode: passwordFocusNode,
          prefixIcon: Icon(
            Icons.vpn_key,
          ),
        ),
        SizedBox(height: size.height * 0.03),
        GradienButton('Login', _loginPressed)
      ],
    );
  }
}

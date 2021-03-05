import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/auth.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/shared/toast.dart';

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
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(navigatorKey.currentState.context);
    super.initState();
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("This is a Custom Toast"),
      ],
    ),
  );

  void _loginPressed() async {
    var username = _usernameFilter.text;
    var password = _passwordFilter.text;

    await login(username, password)
        .then((AuthenticationResponse response) async {
      if (response == null) return null;
      await create(username, response);
      return Navigator.pushReplacementNamed(context, '/home');
    }).catchError((onError) => log(onError.toString()));
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

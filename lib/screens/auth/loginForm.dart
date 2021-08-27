import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/models/jellyfin/authenticationResponse.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/auth/authService.dart';
import 'package:jellyflut/shared/toast.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key, required this.onPressed, this.onAuthenticated})
      : super(key: key);

  final VoidCallback onPressed;
  final VoidCallback? onAuthenticated;

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void _loginPressed() async {
    var username = _usernameFilter.text;
    var password = _passwordFilter.text;

    await AuthService.login(username, password)
        .then((AuthenticationResponse response) async {
      await AuthService.create(username, response);
      if (widget.onAuthenticated != null) {
        widget.onAuthenticated!();
      } else {
        await AutoRouter.of(context).replace(HomeRouter());
      }
    }).catchError((onError) {
      showToast(onError.toString(), fToast, duration: Duration(seconds: 6));
    });
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
                        child: TextButton(
                          onPressed: widget.onPressed,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
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
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).accentColor,
          ),
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

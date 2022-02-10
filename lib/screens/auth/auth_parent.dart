import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/components/auth_bubble_indicator.dart';
import 'package:jellyflut/screens/auth/components/lava/lava_builder.dart';
import 'package:jellyflut/screens/auth/login_form.dart';
import 'package:jellyflut/screens/auth/server_form.dart';

import 'components/lava/lava_painter.dart';

class AuthParent extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  AuthParent({Key? key, this.onAuthenticated}) : super(key: key);

  @override
  _AuthParentState createState() => _AuthParentState();
}

class _AuthParentState extends State<AuthParent> {
  final FToast fToast = FToast();
  late Lava lava = Lava(6);
  late final AuthBloc authBloc;

  @override
  void initState() {
    fToast.init(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.errors.listen((String error) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Row(children: [
            Expanded(child: Text(error, maxLines: 3)),
            Icon(Icons.error, color: Colors.red)
          ]),
          width: 600)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: LavaBuilder(
          child: Center(
            child: ListView(children: [
              SizedBox(
                height: paddingTop + 32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('img/jellyfin_logo.png'),
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                      )),
                  SizedBox(width: 24),
                  Hero(
                    tag: 'logo_text',
                    child: Text(
                      'Jellyfin',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 64),
              Align(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state is AuthenticationSuccessful) {
                      if (widget.onAuthenticated != null) {
                        widget.onAuthenticated!();
                      } else {
                        await AutoRouter.of(context).replace(HomeRouter());
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthenticationUnauthenticated ||
                        state is AuthenticationFirstForm ||
                        state is AuthenticationInitialized) {
                      return firstForm(context);
                    } else if (state is AuthenticationServerAdded) {
                      return secondForm(context);
                    } else if (state is AuthenticationUserAdded ||
                        state is AuthenticationInProgress ||
                        state is AuthenticationError) {
                      return secondForm(context);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ]),
          ),
        ));
  }

  Widget firstForm(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(12, 24, 12, 32),
        child: Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            constraints: BoxConstraints(maxHeight: 400, maxWidth: 600),
            child: ServerForm()));
  }

  Widget secondForm(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Card(
          margin: EdgeInsets.fromLTRB(12, 24, 12, 32),
          child: Container(
              padding: EdgeInsets.only(left: 12, right: 12),
              constraints: BoxConstraints(maxHeight: 400, maxWidth: 600),
              child: LoginForm())),
      Positioned.fill(
        top: 0,
        child: Align(
            alignment: Alignment.topCenter,
            child: AuthBubbleIndicator(value: authBloc.server?.name ?? '')),
      ),
    ]);
  }
}

//showToast(, fToast, duration: Duration(seconds: 6));

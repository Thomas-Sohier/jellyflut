import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/components/auth_bubble_indicator.dart';
import 'package:jellyflut/screens/auth/components/lava/lava_builder.dart';
import 'package:jellyflut/screens/auth/login_form.dart';
import 'package:jellyflut/screens/auth/server_form.dart';

import 'components/lava/lava_painter.dart';

@RoutePage(name: "LoginPage")
class AuthParent extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  const AuthParent({super.key, this.onAuthenticated});

  @override
  State<AuthParent> createState() => _AuthParentState();
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
              SizedBox(height: paddingTop + 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('img/jellyfin_logo.png'),
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                      )),
                  const SizedBox(width: 24),
                  Hero(
                    tag: 'logo_text',
                    child: Text(
                      'Jellyfin',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Align(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.authStatus == AuthStatus.authenticated) {
                      if (widget.onAuthenticated != null) {
                        widget.onAuthenticated!();
                      } else {
                        await context.router.root.replace(r.HomeRouter());
                      }
                    }
                  },
                  builder: (context, state) {
                    switch (state.authPage) {
                      case AuthPage.serverPage:
                        return const FirstFormView();
                      case AuthPage.loginPage:
                        return const SecondFormView();
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}

class FirstFormView extends StatelessWidget {
  const FirstFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(12, 24, 12, 32),
        child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 600),
            child: const ServerForm()));
  }
}

class SecondFormView extends StatelessWidget {
  const SecondFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Card(
          margin: const EdgeInsets.fromLTRB(12, 24, 12, 32),
          child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 600),
              child: const LoginForm())),
      Positioned.fill(
          top: 0,
          child: Align(
              alignment: Alignment.topCenter,
              child: AuthBubbleIndicator(
                  value: context.read<AuthBloc>().state.server.name))),
    ]);
  }
}

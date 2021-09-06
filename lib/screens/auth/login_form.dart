import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/gradient_button.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/components/fields.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';

import 'components/theme/input_theme.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  LoginForm({Key? key, this.onAuthenticated}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FormGroup buildForm() => fb.group(<String, Object>{
        'user_username': FormControl<String>(
          value: BlocProvider.of<AuthBloc>(context).username ?? '',
          validators: [Validators.required],
        ),
        'user_password': FormControl<String>(
          value: BlocProvider.of<AuthBloc>(context).userPassword ?? '',
          validators: [Validators.required],
        )
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 38),
              const Text('Connection',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 12),
              UserUsernameField(
                  form: form, onSubmitted: () => form.focus('user_password')),
              const SizedBox(height: 12),
              UserPasswordField(
                  form: form, onSubmitted: () => addUser(form, context)),
              const SizedBox(height: 24),
              actions(children: [
                backButton(form, context),
                const SizedBox(width: 12),
                loginButton(form, context)
              ]),
              const SizedBox(height: 24)
            ],
          );
        });
  }

  Widget actions({required List<Widget> children}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: children);
  }

  Widget backButton(FormGroup form, BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
          onPressed: () => backToFirstForm(form, context),
          style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 6, right: 6),
                  backgroundColor: Colors.white)
              .copyWith(side: buttonBorderSide())
              .copyWith(elevation: buttonElevation()),
          child: Row(children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            Text(
              'Back',
              style: TextStyle(color: Colors.black),
            ),
          ])),
    );
  }

  void backToFirstForm(FormGroup form, BuildContext context) {
    final username = form.value['user_username'].toString();
    final password = form.value['user_password'].toString();
    BlocProvider.of<AuthBloc>(context).userPassword = password;
    BlocProvider.of<AuthBloc>(context).username = username;
    BlocProvider.of<AuthBloc>(context).add(BackToFirstForm());
  }

  Widget loginButton(FormGroup form, BuildContext context) {
    return Expanded(
        child: GradienButton('Login', () => addUser(form, context),
            borderRadius: 4));
  }

  void addUser(FormGroup form, BuildContext context) {
    if (form.valid) {
      final username = form.value['user_username'].toString();
      final password = form.value['user_password'].toString();
      BlocProvider.of<AuthBloc>(context)
          .add(RequestAuth(username: username, password: password));
    } else {
      form.markAllAsTouched();
      final regexp = RegExp(r'^[^_]+(?=_)');
      final errors = <String>[];
      form.errors.forEach((key, value) {
        final fieldName =
            key.replaceAll(regexp, '').replaceAll('_', '').capitalize();
        errors.add(fieldName + ' is required');
      });
      BlocProvider.of<AuthBloc>(context)
          .add(AuthError('Form is not valid \n${errors.join(',\n')}'));
    }
  }
}

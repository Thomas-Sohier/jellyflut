import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/gradient_button.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/components/fields.dart';
import 'package:jellyflut/screens/auth/enum/fields_enum.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';

class ServerForm extends StatefulWidget {
  const ServerForm();

  @override
  State<StatefulWidget> createState() {
    return _ServerFormState();
  }
}

class _ServerFormState extends State<ServerForm> {
  final urlPattern = RegExp(
      r'((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+(:[0-9]+)?|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)');

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsType.SERVER_NAME.toString(): FormControl<String>(
          value: BlocProvider.of<AuthBloc>(context).server?.name ?? '',
          validators: [Validators.required],
        ),
        FieldsType.SERVER_URL.toString(): FormControl<String>(
          value: BlocProvider.of<AuthBloc>(context).server?.url ?? '',
          validators: [
            Validators.required,
            Validators.pattern(urlPattern,
                validationMessage: 'url_not_correct'.tr())
          ],
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
              const SizedBox(height: 24),
              Text(
                'server_configuration'.tr(),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ServerNameField(
                  form: form,
                  onSubmitted: () =>
                      form.focus(FieldsType.SERVER_URL.toString())),
              const SizedBox(height: 12),
              ServerUrlField(form: form, onSubmitted: () => addServer(form)),
              const SizedBox(height: 24),
              GradienButton('add_server'.tr(), () => addServer(form),
                  borderRadius: 4),
              const SizedBox(height: 24),
            ],
          );
        });
  }

  void addServer(FormGroup form) {
    if (form.valid) {
      final server = Server(
          name: form.value[FieldsType.SERVER_NAME.toString()].toString(),
          url: form.value[FieldsType.SERVER_URL.toString()].toString(),
          id: 0);
      BlocProvider.of<AuthBloc>(context).add(AuthServerAdded(server));
    } else {
      form.markAllAsTouched();
      final regexp = RegExp(r'^[^_]+(?=_)');
      final errors = <String>[];
      form.errors.forEach((key, value) {
        final fieldName =
            key.replaceAll(regexp, '').replaceAll('_', '').capitalize();
        errors.add('field_required'.tr(args: [fieldName]));
      });
      BlocProvider.of<AuthBloc>(context)
          .add(AuthError('form_not_valid'.tr() + '\n${errors.join(',\n')}'));
    }
  }
}

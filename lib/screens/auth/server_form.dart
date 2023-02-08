import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/gradient_button.dart';
import 'package:jellyflut/components/locale_button_selector.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/components/fields.dart';
import 'package:jellyflut/screens/auth/enum/fields_enum.dart';
import 'package:jellyflut/screens/auth/models/server_dto.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ServerForm extends StatefulWidget {
  const ServerForm();

  @override
  State<StatefulWidget> createState() {
    return _ServerFormState();
  }
}

class _ServerFormState extends State<ServerForm> {
  late final AuthBloc authBloc;
  final urlPattern = RegExp(
      r'((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+(:[0-9]+)?|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)');

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsType.SERVER_NAME.value: FormControl<String>(
          value: authBloc.state.server.name,
          validators: [Validators.required],
        ),
        FieldsType.SERVER_URL.value: FormControl<String>(
          value: authBloc.state.server.url,
          validators: [Validators.required, Validators.pattern(urlPattern, validationMessage: 'url_not_correct'.tr())],
        )
      });

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

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
              Row(children: [
                Expanded(
                  child: Text(
                    'server_configuration'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                LocaleButtonSelector(showCurrentValue: true)
              ]),
              const SizedBox(height: 24),
              ServerNameField(form: form, onSubmitted: (_) => form.focus(FieldsType.SERVER_URL.toString())),
              const SizedBox(height: 12),
              ServerUrlField(form: form, onSubmitted: (_) => addServer(form)),
              const SizedBox(height: 24),
              GradienButton('add_server'.tr(), () => addServer(form),
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  color1: Theme.of(context).colorScheme.primary,
                  color2: Theme.of(context).colorScheme.tertiary,
                  borderRadius: 4),
              const SizedBox(height: 24),
            ],
          );
        });
  }

  void addServer(FormGroup form) {
    if (form.valid) {
      final server = ServerDto(
          name: form.value[FieldsType.SERVER_NAME.value].toString(),
          url: form.value[FieldsType.SERVER_URL.value].toString());
      authBloc.add(AuthServerAdded(server));
    } else {
      form.markAllAsTouched();
      final regexp = RegExp(r'^[^_]+(?=_)');
      final errors = <String>[];
      form.errors.forEach((key, value) {
        final fieldName = key.replaceAll(regexp, '').replaceAll('_', '').capitalize();
        errors.add('field_required'.tr(args: [fieldName]));
      });
      authBloc.add(AuthError('${'form_not_valid'.tr()}\n${errors.join(',\n')}'));
    }
  }
}

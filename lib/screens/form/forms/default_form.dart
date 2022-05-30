import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'fields/fields.dart';
import 'fields/fields_enum.dart';

class DefaultForm extends StatefulWidget {
  final Item item;

  const DefaultForm({required this.item});

  @override
  State<DefaultForm> createState() => _DefaultFormState();
}

class _DefaultFormState extends State<DefaultForm> {
  late final FormGroup form;
  late final Item item;
  late final FormBloc<Item> _formBloc;
  late final StreamSubscription<ControlStatus> _subFormChange;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    form = buildForm();
    _subFormChange = form.statusChanged.listen((event) {});
    _subFormChange.onData((status) {
      if (status == ControlStatus.valid) {
        _formBloc.add(CurrentForm<Item>(formGroup: form, value: item));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formBloc = BlocProvider.of<FormBloc<Item>>(context);
  }

  @override
  void dispose() {
    _subFormChange.cancel();
    form.dispose();
    super.dispose();
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsEnum.NAME.getName(): FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.getName():
            FormControl<String>(value: item.originalTitle),
        FieldsEnum.PRODUCTIONYEAR.getName():
            FormControl<int>(value: item.productionYear),
        FieldsEnum.OVERVIEW.getName():
            FormControl<String>(value: item.overview),
        FieldsEnum.DATECREATED.getName():
            FormControl<DateTime>(value: item.dateCreated)
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                TitleField(form: form),
                const SizedBox(height: 24.0),
                OriginalTitleField(form: form),
                const SizedBox(height: 24.0),
                ProductionYearField(form: form),
                const SizedBox(height: 24.0),
                OverviewField(form: form),
                const SizedBox(height: 24.0),
                DateCreatedField(form: form),
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/foundation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../fields/fields_enum.dart';

part 'initial_form_builder.dart';
part 'initial_item_form_builder.dart';
part 'movie_form_builder.dart';

@immutable
abstract class FormBuilder {
  final Item item;
  late final FormGroup formGroup;

  FormBuilder({required this.item}) {
    formGroup = _buildForm();
  }

  FormGroup _buildForm() => throw UnimplementedError('_buildForm needs to be implemented');

  Item formToItem() => throw UnimplementedError('formToItem needs to be implemented');

  dynamic getFormValue(String name) => formGroup.control(name).value;
}

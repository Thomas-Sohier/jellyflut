part of 'form_builder.dart';

class InitialFormBuilder extends FormBuilder {
  InitialFormBuilder({required super.item});

  @override
  FormGroup _buildForm() => fb.group(<String, Object>{});

  @override
  Item formToItem() {
    return item.copyWith.call();
  }
}

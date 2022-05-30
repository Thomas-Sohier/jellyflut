import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

/// This mixin allow to handle focus while tabs is inactive
/// It prevent the cursor from focusing off-screen tab while using d-pad
mixin DetailsMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DetailsBloc get getDetailsBloc => BlocProvider.of<DetailsBloc>(context);
}

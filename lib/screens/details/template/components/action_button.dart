import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button/download_animation.dart';
import 'package:jellyflut/screens/details/template/components/dialog_structure.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/buttons/buttons.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/toast.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

part 'action_button/download_button.dart';
part 'action_button/like_button.dart';
part 'action_button/manage_buton.dart';
part 'action_button/play_button.dart';
part 'action_button/trailer_button.dart';
part 'action_button/viewed_button.dart';

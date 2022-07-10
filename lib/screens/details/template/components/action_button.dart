import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/mixins/details_theme_grabber.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button/download_animation.dart';
import 'package:jellyflut/screens/details/template/components/dialog_structure.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/toast.dart';
import 'package:jellyflut/shared/utils/item_util.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlite_database/sqlite_database.dart';

part 'action_button/download_button.dart';
part 'action_button/like_button.dart';
part 'action_button/manage_buton.dart';
part 'action_button/play_button.dart';
part 'action_button/trailer_button.dart';
part 'action_button/viewed_button.dart';

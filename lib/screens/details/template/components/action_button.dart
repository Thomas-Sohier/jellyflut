import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/dialog_structure.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart' hide ScreenLayout;
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut/theme/theme_extend_own.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:streaming_repository/streaming_repository.dart';

import '../../details_download_cubit/details_download_cubit.dart';

part 'action_button/download_button.dart';
part 'action_button/like_button.dart';
part 'action_button/manage_buton.dart';
part 'action_button/play_button.dart';
part 'action_button/trailer_button.dart';
part 'action_button/viewed_button.dart';

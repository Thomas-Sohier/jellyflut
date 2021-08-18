import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/authParent.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/epub/epubReader.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/musicPlayer/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/routes/playlist.dart';
import 'package:jellyflut/screens/settings/settings.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:jellyflut/services/auth/authService.dart';

import 'router.gr.dart';

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

@CustomAutoRouter(
  // durationInMilliseconds: 250,
  routes: <AutoRoute>[
    AutoRoute(page: AuthParent),
    AutoRoute(page: Home, guards: [AuthGuard], initial: true),
    AutoRoute(page: Details, guards: [AuthGuard]),
    CustomRoute(
        page: Settings,
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: MusicPlayer, guards: [AuthGuard]),
    AutoRoute(page: CollectionMain, guards: [AuthGuard]),
    CustomRoute(
        page: Playlist,
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: Stream, guards: [AuthGuard], maintainState: false),
    AutoRoute(page: EpubReaderPage, guards: [AuthGuard]),
  ],
)
class $AppRouter {}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (!await AuthService.isAuth()) {
      await router.replaceAll([
        AuthParentRoute(onAuthenticated: () {
          router.removeLast();
          resolver.next(true);
        }),
      ]);
    } else {
      resolver.next(true);
    }
  }
}

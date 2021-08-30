import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/authParent.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/epub/epubReader.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/home/homeParent.dart';
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
    AutoRoute(page: AuthParent, path: 'authentication'),
    AutoRoute(
        page: HomeParent,
        path: 'home',
        name: 'HomeRouter',
        guards: [AuthGuard],
        initial: true,
        children: [
          AutoRoute(page: Home, name: 'HomeRoute', initial: true, path: ''),
          AutoRoute(
              page: CollectionMain,
              name: 'CollectionRoute',
              guards: [AuthGuard]),
          RedirectRoute(path: '*', redirectTo: ''),
        ]),
    CustomRoute(
        page: CollectionMain,
        name: 'CollectionMainRoute',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: Details, path: 'details'),
    CustomRoute(
        page: Settings,
        path: 'settings',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: MusicPlayer, path: 'music-player', guards: [AuthGuard]),
    CustomRoute(
        page: Playlist,
        path: 'playlist',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(
        page: Stream,
        path: 'stream',
        guards: [AuthGuard],
        maintainState: false),
    AutoRoute(page: EpubReaderPage, path: 'epub', guards: [AuthGuard]),
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
import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/auth_parent.dart';
import 'package:jellyflut/screens/collection/collection_parent.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/book/book_reader.dart';
import 'package:jellyflut/screens/downloads/downloads_parent.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/home/home_parent.dart';
import 'package:jellyflut/screens/iptv/iptv.dart';
import 'package:jellyflut/screens/musicPlayer/music_player.dart';
import 'package:jellyflut/screens/musicPlayer/routes/playlist.dart';
import 'package:jellyflut/screens/settings/settings.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:jellyflut/services/auth/auth_service.dart';

import 'router.gr.dart';

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

@CustomAutoRouter(
  // durationInMilliseconds: 250,
  routes: <AutoRoute>[
    AutoRoute(page: AuthParent, path: 'authentication'),
    AutoRoute(page: HomeParent, path: 'home', name: 'HomeRouter', guards: [
      AuthGuard
    ], children: [
      AutoRoute(page: Home, name: 'HomeRoute', initial: true, path: ''),
      AutoRoute(
          page: CollectionParent, name: 'CollectionRoute', guards: [AuthGuard]),
      AutoRoute(page: Iptv, name: 'IptvRoute', guards: [AuthGuard]),
      RedirectRoute(path: '*', redirectTo: ''),
    ]),
    CustomRoute(
        page: CollectionParent,
        name: 'CollectionParentRoute',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: Details, path: 'details', guards: [AuthGuard]),
    CustomRoute(
        page: DownloadsParent,
        path: 'downloads',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
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
    CustomRoute(
        page: Stream,
        path: 'stream',
        transitionsBuilder: TransitionsBuilders.zoomIn,
        guards: [AuthGuard]),
    AutoRoute(page: BookReaderPage, path: 'epub', guards: [AuthGuard]),
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

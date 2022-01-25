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
import 'package:jellyflut/screens/server/server_parent.dart';
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
      AutoRoute(page: Home, name: 'HomeRoute', path: '', initial: true),
      AutoRoute(
          page: CollectionParent,
          name: 'CollectionRoute',
          path: 'collection',
          guards: [AuthGuard]),
      AutoRoute(
          page: Iptv, name: 'IptvRoute', path: 'iptv', guards: [AuthGuard]),
      RedirectRoute(path: '*', redirectTo: ''),
    ]),
    CustomRoute(
        page: CollectionParent,
        name: 'collectionParentRoute',
        path: 'collection',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: Details, path: 'details', guards: [AuthGuard]),
    CustomRoute(
        page: DownloadsParent,
        name: 'downloadsRoute',
        path: 'downloads',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    CustomRoute(
        page: Settings,
        name: 'settingsRoute',
        path: 'settings',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    AutoRoute(page: MusicPlayer, path: 'musicPlayer', guards: [AuthGuard]),
    CustomRoute(
        page: ServerParent,
        name: 'serversRoute',
        path: 'servers',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    CustomRoute(
        page: Playlist,
        name: 'playlistRoute',
        path: 'playlist',
        transitionsBuilder: TransitionsBuilders.slideLeft,
        guards: [AuthGuard]),
    CustomRoute(
        page: Stream,
        name: 'streamRoute',
        path: 'stream',
        transitionsBuilder: TransitionsBuilders.zoomIn,
        guards: [AuthGuard]),
    AutoRoute(
        page: BookReaderPage,
        name: 'epubRoute',
        path: 'epub',
        guards: [AuthGuard]),
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

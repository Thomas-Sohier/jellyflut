import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/auth_parent.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/book/book_reader.dart';
import 'package:jellyflut/screens/collection/collection_parent.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/downloads/downloads_parent.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/home/home_parent.dart';
import 'package:jellyflut/screens/live_tv/live_tv.dart';
import 'package:jellyflut/screens/music_player/music_player.dart';
import 'package:jellyflut/screens/music_player/routes/playlist.dart';
import 'package:jellyflut/screens/server/server_parent.dart';
import 'package:jellyflut/screens/settings/settings.dart';
import 'package:jellyflut/screens/stream/stream.dart';

import 'router.gr.dart' as r;

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    ...authRouter,
    ...mainRouter,
  ],
)
class $AppRouter {}

const authRouter = [
  AutoRoute(page: AuthParent, path: 'login', name: 'LoginPage'),
];

const mainRouter = [
  AutoRoute(
      page: HomeParent,
      guards: [AuthGuard],
      path: 'home',
      name: 'HomeRouter',
      initial: true,
      children: [
        AutoRoute(
          page: HomePage,
          guards: [AuthGuard],
          path: '',
          initial: true,
          name: 'HomePage',
        ),
        AutoRoute(
          page: CollectionParent,
          guards: [AuthGuard],
          path: 'collection',
          name: 'CollectionPage',
        ),
        AutoRoute(
          page: LiveTvPage,
          guards: [AuthGuard],
          path: 'live_tv',
          name: 'liveTvPage',
        ),
      ]),
  CustomRoute(
      page: CollectionParent,
      guards: [AuthGuard],
      path: 'collection',
      name: 'collectionPage',
      transitionsBuilder: TransitionsBuilders.slideLeft),
  CustomRoute(
      page: DetailsPage,
      guards: [AuthGuard],
      path: 'details',
      name: 'DetailsPage',
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade),
  CustomRoute(
      page: DownloadsParent,
      guards: [AuthGuard],
      path: 'downloads',
      name: 'DownloadsPage',
      transitionsBuilder: TransitionsBuilders.slideLeft),
  CustomRoute(
    page: Settings,
    guards: [AuthGuard],
    path: 'settings',
    name: 'SettingsPage',
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  AutoRoute(
    page: MusicPlayer,
    guards: [AuthGuard],
    path: 'music_player',
    name: 'MusicPlayerPage',
  ),
  CustomRoute(
    page: ServerParent,
    guards: [AuthGuard],
    path: 'servers',
    name: 'ServersPage',
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    page: Playlist,
    guards: [AuthGuard],
    path: 'playlist',
    name: 'PlaylistPage',
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    page: StreamPage,
    guards: [AuthGuard],
    path: 'stream',
    name: 'StreamPage',
    transitionsBuilder: TransitionsBuilders.fadeIn,
  ),
  AutoRoute(
    page: BookReaderPage,
    guards: [AuthGuard],
    path: 'epub',
    name: 'EpubPage',
  ),
  RedirectRoute(path: '*', redirectTo: 'home'),
];

class AuthGuard extends AutoRouteGuard {
  AuthBloc authBloc;

  AuthGuard({required this.authBloc});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (authBloc.state.authStatus != AuthStatus.authenticated) {
      await router.replaceAll([
        r.LoginPage(onAuthenticated: () {
          router.removeLast();
          resolver.next(true);
        }),
      ]);
    } else {
      resolver.next(true);
    }
  }
}

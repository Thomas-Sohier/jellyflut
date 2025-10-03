import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import 'package:jellyflut_models/jellyflut_models.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page|Parent,Route')
class AppRouter extends RootStackRouter {
  late final AuthGuard authGuard;

  AppRouter({required authBloc, super.navigatorKey}) {
    authGuard = AuthGuard(authBloc: authBloc);
  }

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, path: '/login'),
    AutoRoute(
      page: RouteHomeRoute.page,
      path: '/',
      initial: true,
      guards: [authGuard],
      children: [
        AutoRoute(maintainState: false, page: HomeRoute.page, path: '', guards: [authGuard]),
        AutoRoute(maintainState: false, page: CollectionRoute.page, path: 'collection', guards: [authGuard]),
        AutoRoute(maintainState: false, page: LiveTvRoute.page, path: 'live_tv', guards: [authGuard]),
      ],
    ),
    CustomRoute(
      page: CollectionRoute.page,
      path: '/collection',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: DetailsRoute.page,
      path: '/details',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute(
      page: DownloadsRoute.page,
      path: '/downloads',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: SettingsRoute.page,
      path: '/settings',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    AutoRoute(page: MusicPlayerRoute.page, path: '/music_player', guards: [authGuard]),
    CustomRoute(
      page: ServerRoute.page,
      path: '/servers',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: PlaylistRoute.page,
      path: '/playlist',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: StreamRoute.page,
      path: '/stream',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    AutoRoute(page: BookReaderRoute.page, path: '/epub', guards: [authGuard]),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}

class AuthGuard extends AutoRouteGuard {
  final AuthBloc authBloc;

  AuthGuard({required this.authBloc});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (authBloc.state.authStatus != AuthStatus.authenticated) {
      // 3. Utilisation de la nouvelle classe de route générée (AuthRoute).
      await router.replaceAll([
        AuthRoute(
          onAuthenticated: () {
            router.removeLast();
            resolver.next(true);
          },
        ),
      ]);
    } else {
      resolver.next(true);
    }
  }
}

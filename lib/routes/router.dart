import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';

import 'router.gr.dart' as r;

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AuthBloc authBloc;

  AppRouter({required this.authBloc});

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(page: r.LoginPage.page, path: '/login'),
    AutoRoute(
        page: r.HomeRouter.page,
        guards: [AuthGuard(authBloc: authBloc)],
        path: '/home',
        initial: true,
        children: [
          AutoRoute(
            page: r.HomePage.page,
            guards: [AuthGuard(authBloc: authBloc)],
            path: '',
            initial: true,
          ),
          AutoRoute(
            page: r.CollectionPage.page,
            guards: [AuthGuard(authBloc: authBloc)],
            path: 'collection',
          ),
          AutoRoute(
            page: r.LiveTvPage.page,
            guards: [AuthGuard(authBloc: authBloc)],
            path: 'live_tv',
          ),
        ]),
    CustomRoute(
        page: r.CollectionPage.page,
        guards: [AuthGuard(authBloc: authBloc)],
        path: '/collection',
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        page: r.DetailsPage.page,
        guards: [AuthGuard(authBloc: authBloc)],
        path: '/details',
        transitionsBuilder: TransitionsBuilders.slideLeftWithFade),
    CustomRoute(
        page: r.DownloadsPage.page,
        guards: [AuthGuard(authBloc: authBloc)],
        path: '/downloads',
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
      page: r.ServersPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/settings',
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    AutoRoute(
      page: r.MusicPlayerPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/music_player',
    ),
    CustomRoute(
      page: r.ServersPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/servers',
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: r.PlaylistPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/playlist',
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: r.StreamPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/stream',
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    AutoRoute(
      page: r.EpubPage.page,
      guards: [AuthGuard(authBloc: authBloc)],
      path: '/epub',
    ),
    RedirectRoute(path: '*', redirectTo: '/home'),
  ];
}

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

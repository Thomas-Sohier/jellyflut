// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:jellyflut_models/jellyflut_models.dart' as _i17;

import '../screens/auth/auth_parent.dart' as _i1;
import '../screens/book/book_reader.dart' as _i11;
import '../screens/collection/collection_parent.dart' as _i3;
import '../screens/details/details.dart' as _i4;
import '../screens/downloads/downloads_parent.dart' as _i5;
import '../screens/home/home.dart' as _i12;
import '../screens/home/home_parent.dart' as _i2;
import '../screens/iptv/iptv.dart' as _i13;
import '../screens/music_player/music_player.dart' as _i7;
import '../screens/music_player/routes/playlist.dart' as _i9;
import '../screens/server/server_parent.dart' as _i8;
import '../screens/settings/settings.dart' as _i6;
import '../screens/stream/stream.dart' as _i10;
import 'router.dart' as _i16;

class AppRouter extends _i14.RootStackRouter {
  AppRouter(
      {_i15.GlobalKey<_i15.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i16.AuthGuard authGuard;

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    AuthParentRoute.name: (routeData) {
      final args = routeData.argsAs<AuthParentRouteArgs>(
          orElse: () => const AuthParentRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i1.AuthParent(
              key: args.key, onAuthenticated: args.onAuthenticated),
          opaque: true,
          barrierDismissible: false);
    },
    HomeRouter.name: (routeData) {
      final args = routeData.argsAs<HomeRouterArgs>(
          orElse: () => const HomeRouterArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.HomeParent(key: args.key),
          opaque: true,
          barrierDismissible: false);
    },
    CollectionParentRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionParentRouteArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.CollectionParent(key: args.key, item: args.item),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    DetailsRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsRouteArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.Details(item: args.item, heroTag: args.heroTag),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeftWithFade,
          opaque: true,
          barrierDismissible: false);
    },
    DownloadsRoute.name: (routeData) {
      final args = routeData.argsAs<DownloadsRouteArgs>(
          orElse: () => const DownloadsRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.DownloadsParent(key: args.key),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    SettingsRoute.name: (routeData) {
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i6.Settings(),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    MusicPlayerRoute.name: (routeData) {
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i7.MusicPlayer(),
          opaque: true,
          barrierDismissible: false);
    },
    ServersRoute.name: (routeData) {
      final args = routeData.argsAs<ServersRouteArgs>(
          orElse: () => const ServersRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i8.ServerParent(key: args.key),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    PlaylistRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistRouteArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.Playlist(key: args.key, body: args.body),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    StreamRoute.name: (routeData) {
      final args = routeData.argsAs<StreamRouteArgs>(
          orElse: () => const StreamRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i10.Stream(item: args.item, url: args.url),
          transitionsBuilder: _i14.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EpubRoute.name: (routeData) {
      final args = routeData.argsAs<EpubRouteArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i11.BookReaderPage(key: args.key, item: args.item),
          opaque: true,
          barrierDismissible: false);
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i12.Home(key: args.key),
          opaque: true,
          barrierDismissible: false);
    },
    CollectionRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionRouteArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.CollectionParent(key: args.key, item: args.item),
          opaque: true,
          barrierDismissible: false);
    },
    IptvRoute.name: (routeData) {
      final args =
          routeData.argsAs<IptvRouteArgs>(orElse: () => const IptvRouteArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i13.Iptv(key: args.key),
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(AuthParentRoute.name, path: 'authentication'),
        _i14.RouteConfig(HomeRouter.name, path: 'home', guards: [
          authGuard
        ], children: [
          _i14.RouteConfig(HomeRoute.name, path: '', parent: HomeRouter.name),
          _i14.RouteConfig(CollectionRoute.name,
              path: 'collection', parent: HomeRouter.name, guards: [authGuard]),
          _i14.RouteConfig(IptvRoute.name,
              path: 'iptv', parent: HomeRouter.name, guards: [authGuard]),
          _i14.RouteConfig('*#redirect',
              path: '*',
              parent: HomeRouter.name,
              redirectTo: '',
              fullMatch: true)
        ]),
        _i14.RouteConfig(CollectionParentRoute.name,
            path: 'collection', guards: [authGuard]),
        _i14.RouteConfig(DetailsRoute.name,
            path: 'details', guards: [authGuard]),
        _i14.RouteConfig(DownloadsRoute.name,
            path: 'downloads', guards: [authGuard]),
        _i14.RouteConfig(SettingsRoute.name,
            path: 'settings', guards: [authGuard]),
        _i14.RouteConfig(MusicPlayerRoute.name,
            path: 'musicPlayer', guards: [authGuard]),
        _i14.RouteConfig(ServersRoute.name,
            path: 'servers', guards: [authGuard]),
        _i14.RouteConfig(PlaylistRoute.name,
            path: 'playlist', guards: [authGuard]),
        _i14.RouteConfig(StreamRoute.name, path: 'stream', guards: [authGuard]),
        _i14.RouteConfig(EpubRoute.name, path: 'epub', guards: [authGuard])
      ];
}

/// generated route for
/// [_i1.AuthParent]
class AuthParentRoute extends _i14.PageRouteInfo<AuthParentRouteArgs> {
  AuthParentRoute({_i15.Key? key, void Function()? onAuthenticated})
      : super(AuthParentRoute.name,
            path: 'authentication',
            args: AuthParentRouteArgs(
                key: key, onAuthenticated: onAuthenticated));

  static const String name = 'AuthParentRoute';
}

class AuthParentRouteArgs {
  const AuthParentRouteArgs({this.key, this.onAuthenticated});

  final _i15.Key? key;

  final void Function()? onAuthenticated;

  @override
  String toString() {
    return 'AuthParentRouteArgs{key: $key, onAuthenticated: $onAuthenticated}';
  }
}

/// generated route for
/// [_i2.HomeParent]
class HomeRouter extends _i14.PageRouteInfo<HomeRouterArgs> {
  HomeRouter({_i15.Key? key, List<_i14.PageRouteInfo>? children})
      : super(HomeRouter.name,
            path: 'home',
            args: HomeRouterArgs(key: key),
            initialChildren: children);

  static const String name = 'HomeRouter';
}

class HomeRouterArgs {
  const HomeRouterArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'HomeRouterArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.CollectionParent]
class CollectionParentRoute
    extends _i14.PageRouteInfo<CollectionParentRouteArgs> {
  CollectionParentRoute({_i15.Key? key, required _i17.Item item})
      : super(CollectionParentRoute.name,
            path: 'collection',
            args: CollectionParentRouteArgs(key: key, item: item));

  static const String name = 'CollectionParentRoute';
}

class CollectionParentRouteArgs {
  const CollectionParentRouteArgs({this.key, required this.item});

  final _i15.Key? key;

  final _i17.Item item;

  @override
  String toString() {
    return 'CollectionParentRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i4.Details]
class DetailsRoute extends _i14.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({required _i17.Item item, required String? heroTag})
      : super(DetailsRoute.name,
            path: 'details',
            args: DetailsRouteArgs(item: item, heroTag: heroTag));

  static const String name = 'DetailsRoute';
}

class DetailsRouteArgs {
  const DetailsRouteArgs({required this.item, required this.heroTag});

  final _i17.Item item;

  final String? heroTag;

  @override
  String toString() {
    return 'DetailsRouteArgs{item: $item, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i5.DownloadsParent]
class DownloadsRoute extends _i14.PageRouteInfo<DownloadsRouteArgs> {
  DownloadsRoute({_i15.Key? key})
      : super(DownloadsRoute.name,
            path: 'downloads', args: DownloadsRouteArgs(key: key));

  static const String name = 'DownloadsRoute';
}

class DownloadsRouteArgs {
  const DownloadsRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'DownloadsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.Settings]
class SettingsRoute extends _i14.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i7.MusicPlayer]
class MusicPlayerRoute extends _i14.PageRouteInfo<void> {
  const MusicPlayerRoute() : super(MusicPlayerRoute.name, path: 'musicPlayer');

  static const String name = 'MusicPlayerRoute';
}

/// generated route for
/// [_i8.ServerParent]
class ServersRoute extends _i14.PageRouteInfo<ServersRouteArgs> {
  ServersRoute({_i15.Key? key})
      : super(ServersRoute.name,
            path: 'servers', args: ServersRouteArgs(key: key));

  static const String name = 'ServersRoute';
}

class ServersRouteArgs {
  const ServersRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'ServersRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.Playlist]
class PlaylistRoute extends _i14.PageRouteInfo<PlaylistRouteArgs> {
  PlaylistRoute({_i15.Key? key, required _i15.Widget body})
      : super(PlaylistRoute.name,
            path: 'playlist', args: PlaylistRouteArgs(key: key, body: body));

  static const String name = 'PlaylistRoute';
}

class PlaylistRouteArgs {
  const PlaylistRouteArgs({this.key, required this.body});

  final _i15.Key? key;

  final _i15.Widget body;

  @override
  String toString() {
    return 'PlaylistRouteArgs{key: $key, body: $body}';
  }
}

/// generated route for
/// [_i10.Stream]
class StreamRoute extends _i14.PageRouteInfo<StreamRouteArgs> {
  StreamRoute({_i17.Item? item, String? url})
      : super(StreamRoute.name,
            path: 'stream', args: StreamRouteArgs(item: item, url: url));

  static const String name = 'StreamRoute';
}

class StreamRouteArgs {
  const StreamRouteArgs({this.item, this.url});

  final _i17.Item? item;

  final String? url;

  @override
  String toString() {
    return 'StreamRouteArgs{item: $item, url: $url}';
  }
}

/// generated route for
/// [_i11.BookReaderPage]
class EpubRoute extends _i14.PageRouteInfo<EpubRouteArgs> {
  EpubRoute({_i15.Key? key, required _i17.Item item})
      : super(EpubRoute.name,
            path: 'epub', args: EpubRouteArgs(key: key, item: item));

  static const String name = 'EpubRoute';
}

class EpubRouteArgs {
  const EpubRouteArgs({this.key, required this.item});

  final _i15.Key? key;

  final _i17.Item item;

  @override
  String toString() {
    return 'EpubRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i12.Home]
class HomeRoute extends _i14.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i15.Key? key})
      : super(HomeRoute.name, path: '', args: HomeRouteArgs(key: key));

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.CollectionParent]
class CollectionRoute extends _i14.PageRouteInfo<CollectionRouteArgs> {
  CollectionRoute({_i15.Key? key, required _i17.Item item})
      : super(CollectionRoute.name,
            path: 'collection',
            args: CollectionRouteArgs(key: key, item: item));

  static const String name = 'CollectionRoute';
}

class CollectionRouteArgs {
  const CollectionRouteArgs({this.key, required this.item});

  final _i15.Key? key;

  final _i17.Item item;

  @override
  String toString() {
    return 'CollectionRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i13.Iptv]
class IptvRoute extends _i14.PageRouteInfo<IptvRouteArgs> {
  IptvRoute({_i15.Key? key})
      : super(IptvRoute.name, path: 'iptv', args: IptvRouteArgs(key: key));

  static const String name = 'IptvRoute';
}

class IptvRouteArgs {
  const IptvRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'IptvRouteArgs{key: $key}';
  }
}

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;

import '../models/jellyfin/item.dart' as _i16;
import '../screens/auth/auth_parent.dart' as _i1;
import '../screens/book/book_reader.dart' as _i10;
import '../screens/collection/collection_parent.dart' as _i3;
import '../screens/details/details.dart' as _i4;
import '../screens/downloads/downloads_parent.dart' as _i5;
import '../screens/home/home.dart' as _i11;
import '../screens/home/home_parent.dart' as _i2;
import '../screens/iptv/iptv.dart' as _i12;
import '../screens/musicPlayer/music_player.dart' as _i7;
import '../screens/musicPlayer/routes/playlist.dart' as _i8;
import '../screens/settings/settings.dart' as _i6;
import '../screens/stream/stream.dart' as _i9;
import 'router.dart' as _i15;

class AppRouter extends _i13.RootStackRouter {
  AppRouter(
      {_i14.GlobalKey<_i14.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i15.AuthGuard authGuard;

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    AuthParentRoute.name: (routeData) {
      final args = routeData.argsAs<AuthParentRouteArgs>(
          orElse: () => const AuthParentRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i1.AuthParent(
              key: args.key, onAuthenticated: args.onAuthenticated),
          opaque: true,
          barrierDismissible: false);
    },
    HomeRouter.name: (routeData) {
      final args = routeData.argsAs<HomeRouterArgs>(
          orElse: () => const HomeRouterArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.HomeParent(key: args.key),
          opaque: true,
          barrierDismissible: false);
    },
    CollectionParentRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionParentRouteArgs>();
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.CollectionParent(item: args.item),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    DetailsRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsRouteArgs>();
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.Details(item: args.item, heroTag: args.heroTag),
          opaque: true,
          barrierDismissible: false);
    },
    DownloadsParentRoute.name: (routeData) {
      final args = routeData.argsAs<DownloadsParentRouteArgs>(
          orElse: () => const DownloadsParentRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.DownloadsParent(key: args.key),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    SettingsRoute.name: (routeData) {
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i6.Settings(),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    MusicPlayerRoute.name: (routeData) {
      final args = routeData.argsAs<MusicPlayerRouteArgs>(
          orElse: () => const MusicPlayerRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i7.MusicPlayer(key: args.key),
          opaque: true,
          barrierDismissible: false);
    },
    PlaylistRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistRouteArgs>();
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i8.Playlist(key: args.key, body: args.body),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    StreamRoute.name: (routeData) {
      final args = routeData.argsAs<StreamRouteArgs>(
          orElse: () => const StreamRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.Stream(item: args.item, url: args.url),
          transitionsBuilder: _i13.TransitionsBuilders.zoomIn,
          opaque: true,
          barrierDismissible: false);
    },
    BookReaderPageRoute.name: (routeData) {
      final args = routeData.argsAs<BookReaderPageRouteArgs>();
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i10.BookReaderPage(key: args.key, item: args.item),
          opaque: true,
          barrierDismissible: false);
    },
    HomeRoute.name: (routeData) {
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i11.Home(),
          opaque: true,
          barrierDismissible: false);
    },
    CollectionRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionRouteArgs>();
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.CollectionParent(item: args.item),
          opaque: true,
          barrierDismissible: false);
    },
    IptvRoute.name: (routeData) {
      final args =
          routeData.argsAs<IptvRouteArgs>(orElse: () => const IptvRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i12.Iptv(key: args.key),
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig('/#redirect',
            path: '/', redirectTo: 'home', fullMatch: true),
        _i13.RouteConfig(AuthParentRoute.name, path: 'authentication'),
        _i13.RouteConfig(HomeRouter.name, path: 'home', guards: [
          authGuard
        ], children: [
          _i13.RouteConfig(HomeRoute.name, path: '', parent: HomeRouter.name),
          _i13.RouteConfig(CollectionRoute.name,
              path: 'collection-parent',
              parent: HomeRouter.name,
              guards: [authGuard]),
          _i13.RouteConfig(IptvRoute.name,
              path: 'Iptv', parent: HomeRouter.name, guards: [authGuard]),
          _i13.RouteConfig('*#redirect',
              path: '*',
              parent: HomeRouter.name,
              redirectTo: '',
              fullMatch: true)
        ]),
        _i13.RouteConfig(CollectionParentRoute.name,
            path: '/collection-parent', guards: [authGuard]),
        _i13.RouteConfig(DetailsRoute.name,
            path: 'details', guards: [authGuard]),
        _i13.RouteConfig(DownloadsParentRoute.name,
            path: 'downloads', guards: [authGuard]),
        _i13.RouteConfig(SettingsRoute.name,
            path: 'settings', guards: [authGuard]),
        _i13.RouteConfig(MusicPlayerRoute.name,
            path: 'music-player', guards: [authGuard]),
        _i13.RouteConfig(PlaylistRoute.name,
            path: 'playlist', guards: [authGuard]),
        _i13.RouteConfig(StreamRoute.name, path: 'stream', guards: [authGuard]),
        _i13.RouteConfig(BookReaderPageRoute.name,
            path: 'epub', guards: [authGuard])
      ];
}

/// generated route for
/// [_i1.AuthParent]
class AuthParentRoute extends _i13.PageRouteInfo<AuthParentRouteArgs> {
  AuthParentRoute({_i14.Key? key, void Function()? onAuthenticated})
      : super(AuthParentRoute.name,
            path: 'authentication',
            args: AuthParentRouteArgs(
                key: key, onAuthenticated: onAuthenticated));

  static const String name = 'AuthParentRoute';
}

class AuthParentRouteArgs {
  const AuthParentRouteArgs({this.key, this.onAuthenticated});

  final _i14.Key? key;

  final void Function()? onAuthenticated;

  @override
  String toString() {
    return 'AuthParentRouteArgs{key: $key, onAuthenticated: $onAuthenticated}';
  }
}

/// generated route for
/// [_i2.HomeParent]
class HomeRouter extends _i13.PageRouteInfo<HomeRouterArgs> {
  HomeRouter({_i14.Key? key, List<_i13.PageRouteInfo>? children})
      : super(HomeRouter.name,
            path: 'home',
            args: HomeRouterArgs(key: key),
            initialChildren: children);

  static const String name = 'HomeRouter';
}

class HomeRouterArgs {
  const HomeRouterArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'HomeRouterArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.CollectionParent]
class CollectionParentRoute
    extends _i13.PageRouteInfo<CollectionParentRouteArgs> {
  CollectionParentRoute({required _i16.Item item})
      : super(CollectionParentRoute.name,
            path: '/collection-parent',
            args: CollectionParentRouteArgs(item: item));

  static const String name = 'CollectionParentRoute';
}

class CollectionParentRouteArgs {
  const CollectionParentRouteArgs({required this.item});

  final _i16.Item item;

  @override
  String toString() {
    return 'CollectionParentRouteArgs{item: $item}';
  }
}

/// generated route for
/// [_i4.Details]
class DetailsRoute extends _i13.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({required _i16.Item item, required String? heroTag})
      : super(DetailsRoute.name,
            path: 'details',
            args: DetailsRouteArgs(item: item, heroTag: heroTag));

  static const String name = 'DetailsRoute';
}

class DetailsRouteArgs {
  const DetailsRouteArgs({required this.item, required this.heroTag});

  final _i16.Item item;

  final String? heroTag;

  @override
  String toString() {
    return 'DetailsRouteArgs{item: $item, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i5.DownloadsParent]
class DownloadsParentRoute
    extends _i13.PageRouteInfo<DownloadsParentRouteArgs> {
  DownloadsParentRoute({_i14.Key? key})
      : super(DownloadsParentRoute.name,
            path: 'downloads', args: DownloadsParentRouteArgs(key: key));

  static const String name = 'DownloadsParentRoute';
}

class DownloadsParentRouteArgs {
  const DownloadsParentRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'DownloadsParentRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.Settings]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i7.MusicPlayer]
class MusicPlayerRoute extends _i13.PageRouteInfo<MusicPlayerRouteArgs> {
  MusicPlayerRoute({_i14.Key? key})
      : super(MusicPlayerRoute.name,
            path: 'music-player', args: MusicPlayerRouteArgs(key: key));

  static const String name = 'MusicPlayerRoute';
}

class MusicPlayerRouteArgs {
  const MusicPlayerRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'MusicPlayerRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.Playlist]
class PlaylistRoute extends _i13.PageRouteInfo<PlaylistRouteArgs> {
  PlaylistRoute({_i14.Key? key, required _i14.Widget body})
      : super(PlaylistRoute.name,
            path: 'playlist', args: PlaylistRouteArgs(key: key, body: body));

  static const String name = 'PlaylistRoute';
}

class PlaylistRouteArgs {
  const PlaylistRouteArgs({this.key, required this.body});

  final _i14.Key? key;

  final _i14.Widget body;

  @override
  String toString() {
    return 'PlaylistRouteArgs{key: $key, body: $body}';
  }
}

/// generated route for
/// [_i9.Stream]
class StreamRoute extends _i13.PageRouteInfo<StreamRouteArgs> {
  StreamRoute({_i16.Item? item, String? url})
      : super(StreamRoute.name,
            path: 'stream', args: StreamRouteArgs(item: item, url: url));

  static const String name = 'StreamRoute';
}

class StreamRouteArgs {
  const StreamRouteArgs({this.item, this.url});

  final _i16.Item? item;

  final String? url;

  @override
  String toString() {
    return 'StreamRouteArgs{item: $item, url: $url}';
  }
}

/// generated route for
/// [_i10.BookReaderPage]
class BookReaderPageRoute extends _i13.PageRouteInfo<BookReaderPageRouteArgs> {
  BookReaderPageRoute({_i14.Key? key, required _i16.Item item})
      : super(BookReaderPageRoute.name,
            path: 'epub', args: BookReaderPageRouteArgs(key: key, item: item));

  static const String name = 'BookReaderPageRoute';
}

class BookReaderPageRouteArgs {
  const BookReaderPageRouteArgs({this.key, required this.item});

  final _i14.Key? key;

  final _i16.Item item;

  @override
  String toString() {
    return 'BookReaderPageRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i11.Home]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.CollectionParent]
class CollectionRoute extends _i13.PageRouteInfo<CollectionRouteArgs> {
  CollectionRoute({required _i16.Item item})
      : super(CollectionRoute.name,
            path: 'collection-parent', args: CollectionRouteArgs(item: item));

  static const String name = 'CollectionRoute';
}

class CollectionRouteArgs {
  const CollectionRouteArgs({required this.item});

  final _i16.Item item;

  @override
  String toString() {
    return 'CollectionRouteArgs{item: $item}';
  }
}

/// generated route for
/// [_i12.Iptv]
class IptvRoute extends _i13.PageRouteInfo<IptvRouteArgs> {
  IptvRoute({_i14.Key? key})
      : super(IptvRoute.name, path: 'Iptv', args: IptvRouteArgs(key: key));

  static const String name = 'IptvRoute';
}

class IptvRouteArgs {
  const IptvRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'IptvRouteArgs{key: $key}';
  }
}

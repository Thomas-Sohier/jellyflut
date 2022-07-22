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
import '../screens/live_tv/live_tv.dart' as _i13;
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
    LoginPage.name: (routeData) {
      final args =
          routeData.argsAs<LoginPageArgs>(orElse: () => const LoginPageArgs());
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.AuthParent(
              key: args.key, onAuthenticated: args.onAuthenticated));
    },
    HomeRouter.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomeParent());
    },
    CollectionPage.name: (routeData) {
      final args = routeData.argsAs<CollectionPageArgs>();
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.CollectionParent(key: args.key, item: args.item));
    },
    DetailsPage.name: (routeData) {
      final args = routeData.argsAs<DetailsPageArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.DetailsPage(item: args.item, heroTag: args.heroTag),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeftWithFade,
          opaque: true,
          barrierDismissible: false);
    },
    DownloadsPage.name: (routeData) {
      final args = routeData.argsAs<DownloadsPageArgs>(
          orElse: () => const DownloadsPageArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.DownloadsParent(key: args.key),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    SettingsPage.name: (routeData) {
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i6.Settings(),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    MusicPlayerPage.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.MusicPlayer());
    },
    ServersPage.name: (routeData) {
      final args = routeData.argsAs<ServersPageArgs>(
          orElse: () => const ServersPageArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i8.ServerParent(key: args.key),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    PlaylistPage.name: (routeData) {
      final args = routeData.argsAs<PlaylistPageArgs>();
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.Playlist(key: args.key, body: args.body),
          transitionsBuilder: _i14.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    StreamPage.name: (routeData) {
      final args = routeData.argsAs<StreamPageArgs>(
          orElse: () => const StreamPageArgs());
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: _i10.StreamPage(key: args.key, item: args.item, url: args.url),
          transitionsBuilder: _i14.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EpubPage.name: (routeData) {
      final args = routeData.argsAs<EpubPageArgs>();
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.BookReaderPage(key: args.key, item: args.item));
    },
    HomePage.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i12.HomePage());
    },
    LiveTvPage.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.LiveTvPage());
    }
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig('/#redirect',
            path: '/', redirectTo: 'home', fullMatch: true),
        _i14.RouteConfig(LoginPage.name, path: 'login'),
        _i14.RouteConfig(HomeRouter.name, path: 'home', guards: [
          authGuard
        ], children: [
          _i14.RouteConfig(HomePage.name,
              path: '', parent: HomeRouter.name, guards: [authGuard]),
          _i14.RouteConfig(CollectionPage.name,
              path: 'collection', parent: HomeRouter.name, guards: [authGuard]),
          _i14.RouteConfig(LiveTvPage.name,
              path: 'live_tv', parent: HomeRouter.name, guards: [authGuard])
        ]),
        _i14.RouteConfig(CollectionPage.name,
            path: 'collection', guards: [authGuard]),
        _i14.RouteConfig(DetailsPage.name,
            path: 'details', guards: [authGuard]),
        _i14.RouteConfig(DownloadsPage.name,
            path: 'downloads', guards: [authGuard]),
        _i14.RouteConfig(SettingsPage.name,
            path: 'settings', guards: [authGuard]),
        _i14.RouteConfig(MusicPlayerPage.name,
            path: 'music_player', guards: [authGuard]),
        _i14.RouteConfig(ServersPage.name,
            path: 'servers', guards: [authGuard]),
        _i14.RouteConfig(PlaylistPage.name,
            path: 'playlist', guards: [authGuard]),
        _i14.RouteConfig(StreamPage.name, path: 'stream', guards: [authGuard]),
        _i14.RouteConfig(EpubPage.name, path: 'epub', guards: [authGuard]),
        _i14.RouteConfig('*#redirect',
            path: '*', redirectTo: 'home', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.AuthParent]
class LoginPage extends _i14.PageRouteInfo<LoginPageArgs> {
  LoginPage({_i15.Key? key, void Function()? onAuthenticated})
      : super(LoginPage.name,
            path: 'login',
            args: LoginPageArgs(key: key, onAuthenticated: onAuthenticated));

  static const String name = 'LoginPage';
}

class LoginPageArgs {
  const LoginPageArgs({this.key, this.onAuthenticated});

  final _i15.Key? key;

  final void Function()? onAuthenticated;

  @override
  String toString() {
    return 'LoginPageArgs{key: $key, onAuthenticated: $onAuthenticated}';
  }
}

/// generated route for
/// [_i2.HomeParent]
class HomeRouter extends _i14.PageRouteInfo<void> {
  const HomeRouter({List<_i14.PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i3.CollectionParent]
class CollectionPage extends _i14.PageRouteInfo<CollectionPageArgs> {
  CollectionPage({_i15.Key? key, required _i17.Item item})
      : super(CollectionPage.name,
            path: 'collection', args: CollectionPageArgs(key: key, item: item));

  static const String name = 'CollectionPage';
}

class CollectionPageArgs {
  const CollectionPageArgs({this.key, required this.item});

  final _i15.Key? key;

  final _i17.Item item;

  @override
  String toString() {
    return 'CollectionPageArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i4.DetailsPage]
class DetailsPage extends _i14.PageRouteInfo<DetailsPageArgs> {
  DetailsPage({required _i17.Item item, required String? heroTag})
      : super(DetailsPage.name,
            path: 'details',
            args: DetailsPageArgs(item: item, heroTag: heroTag));

  static const String name = 'DetailsPage';
}

class DetailsPageArgs {
  const DetailsPageArgs({required this.item, required this.heroTag});

  final _i17.Item item;

  final String? heroTag;

  @override
  String toString() {
    return 'DetailsPageArgs{item: $item, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i5.DownloadsParent]
class DownloadsPage extends _i14.PageRouteInfo<DownloadsPageArgs> {
  DownloadsPage({_i15.Key? key})
      : super(DownloadsPage.name,
            path: 'downloads', args: DownloadsPageArgs(key: key));

  static const String name = 'DownloadsPage';
}

class DownloadsPageArgs {
  const DownloadsPageArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'DownloadsPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.Settings]
class SettingsPage extends _i14.PageRouteInfo<void> {
  const SettingsPage() : super(SettingsPage.name, path: 'settings');

  static const String name = 'SettingsPage';
}

/// generated route for
/// [_i7.MusicPlayer]
class MusicPlayerPage extends _i14.PageRouteInfo<void> {
  const MusicPlayerPage() : super(MusicPlayerPage.name, path: 'music_player');

  static const String name = 'MusicPlayerPage';
}

/// generated route for
/// [_i8.ServerParent]
class ServersPage extends _i14.PageRouteInfo<ServersPageArgs> {
  ServersPage({_i15.Key? key})
      : super(ServersPage.name,
            path: 'servers', args: ServersPageArgs(key: key));

  static const String name = 'ServersPage';
}

class ServersPageArgs {
  const ServersPageArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'ServersPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.Playlist]
class PlaylistPage extends _i14.PageRouteInfo<PlaylistPageArgs> {
  PlaylistPage({_i15.Key? key, required _i15.Widget body})
      : super(PlaylistPage.name,
            path: 'playlist', args: PlaylistPageArgs(key: key, body: body));

  static const String name = 'PlaylistPage';
}

class PlaylistPageArgs {
  const PlaylistPageArgs({this.key, required this.body});

  final _i15.Key? key;

  final _i15.Widget body;

  @override
  String toString() {
    return 'PlaylistPageArgs{key: $key, body: $body}';
  }
}

/// generated route for
/// [_i10.StreamPage]
class StreamPage extends _i14.PageRouteInfo<StreamPageArgs> {
  StreamPage({_i15.Key? key, _i17.Item? item, String? url})
      : super(StreamPage.name,
            path: 'stream',
            args: StreamPageArgs(key: key, item: item, url: url));

  static const String name = 'StreamPage';
}

class StreamPageArgs {
  const StreamPageArgs({this.key, this.item, this.url});

  final _i15.Key? key;

  final _i17.Item? item;

  final String? url;

  @override
  String toString() {
    return 'StreamPageArgs{key: $key, item: $item, url: $url}';
  }
}

/// generated route for
/// [_i11.BookReaderPage]
class EpubPage extends _i14.PageRouteInfo<EpubPageArgs> {
  EpubPage({_i15.Key? key, required _i17.Item item})
      : super(EpubPage.name,
            path: 'epub', args: EpubPageArgs(key: key, item: item));

  static const String name = 'EpubPage';
}

class EpubPageArgs {
  const EpubPageArgs({this.key, required this.item});

  final _i15.Key? key;

  final _i17.Item item;

  @override
  String toString() {
    return 'EpubPageArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i12.HomePage]
class HomePage extends _i14.PageRouteInfo<void> {
  const HomePage() : super(HomePage.name, path: '');

  static const String name = 'HomePage';
}

/// generated route for
/// [_i13.LiveTvPage]
class LiveTvPage extends _i14.PageRouteInfo<void> {
  const LiveTvPage() : super(LiveTvPage.name, path: 'live_tv');

  static const String name = 'LiveTvPage';
}

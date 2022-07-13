import 'package:auto_route/auto_route.dart';
import 'package:jellyflut/screens/auth/auth_parent.dart';
import 'package:jellyflut/screens/book/book_reader.dart';
import 'package:jellyflut/screens/collection/collection_parent.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/downloads/downloads_parent.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/home/home_parent.dart';
import 'package:jellyflut/screens/iptv/iptv.dart';
import 'package:jellyflut/screens/music_player/music_player.dart';
import 'package:jellyflut/screens/music_player/routes/playlist.dart';
import 'package:jellyflut/screens/server/server_parent.dart';
import 'package:jellyflut/screens/settings/settings.dart';
import 'package:jellyflut/screens/stream/stream.dart';

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

@CustomAutoRouter(
  // durationInMilliseconds: 250,
  routes: <AutoRoute>[
    AutoRoute(page: AuthParent, path: 'authentication'),
    AutoRoute(page: HomeParent, path: 'home', name: 'HomeRouter', children: [
      AutoRoute(page: Home, name: 'HomeRoute', path: '', initial: true),
      AutoRoute(page: CollectionParent, name: 'CollectionRoute', path: 'collection'),
      AutoRoute(page: Iptv, name: 'IptvRoute', path: 'iptv'),
      RedirectRoute(path: '*', redirectTo: ''),
    ]),
    CustomRoute(
        page: CollectionParent,
        name: 'collectionParentRoute',
        path: 'collection',
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(page: Details, path: 'details', transitionsBuilder: TransitionsBuilders.slideLeftWithFade),
    CustomRoute(
        page: DownloadsParent,
        name: 'downloadsRoute',
        path: 'downloads',
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        page: Settings, name: 'settingsRoute', path: 'settings', transitionsBuilder: TransitionsBuilders.slideLeft),
    AutoRoute(page: MusicPlayer, path: 'musicPlayer'),
    CustomRoute(
        page: ServerParent, name: 'serversRoute', path: 'servers', transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
      page: Playlist,
      name: 'playlistRoute',
      path: 'playlist',
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(page: Stream, name: 'streamRoute', path: 'stream', transitionsBuilder: TransitionsBuilders.fadeIn),
    AutoRoute(page: BookReaderPage, name: 'epubRoute', path: 'epub'),
  ],
)
class $AppRouter {}

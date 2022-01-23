import 'package:jellyflut/globals.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';

class UriUtils {
  static UrlParts extractUriParts(final String uri) {
    // http://www.ics.uci.edu/pub/ietf/uri/#Related
    // results in the following subexpression matches:
    //    $1 = http:
    //    $2 = http
    //    $3 = //www.ics.uci.edu
    //    $4 = www.ics.uci.edu
    //    $5 = /pub/ietf/uri/
    //    $6 = <undefined>
    //    $7 = <undefined>
    //    $8 = #Related
    //    $9 = Related
    final _urlPattern =
        RegExp(r'^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?');
    final matches = _urlPattern.allMatches(uri);
    return UrlParts(matches.elementAt(0).group(2),
        matches.elementAt(0).group(4), matches.elementAt(0).group(9));
  }

  /// Construct an url with query params based of server globals
  /// Can throw an Exception if URL is not valid
  static String contructUrl(
      final String path, Map<String, dynamic>? queryParams) {
    final uriParts = UriUtils.extractUriParts(server.url);
    late final uri;
    if (uriParts.domain == null) {
      throw Exception('Url is not valid');
    } else {
      if (uriParts.http.equalsIgnoreCase('http')) {
        uri =
            Uri.http(uriParts.domain!, uriParts.path ?? '' + path, queryParams);
      } else if (uriParts.http.equalsIgnoreCase('https')) {
        uri = Uri.https(
            uriParts.domain!, uriParts.path ?? '' + path, queryParams);
      } else {
        throw Exception('Url is not valid');
      }

      return uri.toString();
    }
  }
}

class UrlParts {
  final String? http;
  final String? domain;
  final String? path;

  const UrlParts(this.http, this.domain, this.path);
}

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
}

class UrlParts {
  final String? http;
  final String? domain;
  final String? path;

  const UrlParts(this.http, this.domain, this.path);
}

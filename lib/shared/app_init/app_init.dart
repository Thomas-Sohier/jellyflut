// We use a conditional export to expose the right connection factory depending
// on the platform.
export 'unsupported.dart'
    if (dart.library.js) 'app_init_web.dart'
    if (dart.library.ffi) 'app_init_native.dart';

// We use a conditional export to expose the right connection factory depending
// on the platform.
export 'unsupported.dart'
    if (dart.library.js) 'init_stream_web.dart'
    if (dart.library.ffi) 'init_stream_native.dart';

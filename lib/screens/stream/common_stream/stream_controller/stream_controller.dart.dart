// We use a conditional export to expose the right connection factory depending
// on the platform.
export 'unsupported.dart'
    if (dart.library.js) 'stream_controller_web.dart'
    if (dart.library.ffi) 'stream_controller_native.dart';

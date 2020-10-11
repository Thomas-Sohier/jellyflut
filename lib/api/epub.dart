import 'dart:io';

import 'package:flutter/foundation.dart';

var httpClient = new HttpClient();
Future<File> downloadFile(String url, String path) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  // String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File(path);
  await file.writeAsBytes(bytes);
  return file;
}

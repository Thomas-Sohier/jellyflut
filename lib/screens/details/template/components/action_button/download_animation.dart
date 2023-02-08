import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DownloadAnimation extends StatefulWidget {
  final BehaviorSubject<int> percentDownload;
  final Widget child;
  DownloadAnimation({super.key, required this.percentDownload, required this.child});

  @override
  State<DownloadAnimation> createState() => _DownloadAnimationState();
}

class _DownloadAnimationState extends State<DownloadAnimation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.percentDownload,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
            return widget.child;
          } else if (snapshot.hasError) {
            return Icon(Icons.file_download_off, color: Colors.red);
          }

          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data! >= 0 && snapshot.data! < 100) {
                return SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    value: snapshot.data!.toDouble() / 100,
                    backgroundColor: Colors.black54,
                    color: Colors.green,
                    strokeWidth: 3,
                  ),
                );
              }
              return Icon(Icons.download_done, color: Colors.green.shade900);
            }
          }
          return CircularProgressIndicator();
        });
  }
}

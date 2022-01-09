import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/header_bar.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class OffLineScreen extends StatelessWidget {
  final Object? error;
  const OffLineScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    late final IconData iconError;
    late final errorObject = error;

    if (errorObject is DioError) {
      iconError = Icons.signal_wifi_statusbar_connected_no_internet_4;
    } else {
      iconError = Icons.error;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight + 10),
            HeaderBar(),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconError,
                        size: 24, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 18),
                    Text(
                        'You seems to not be able to access your server or to have internet',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
                    const SizedBox(height: 12),
                    PaletteButton('Go to my offline library',
                        borderRadius: 4,
                        minHeight: 40,
                        onPressed: () =>
                            customRouter.push(DownloadsParentRoute())),
                    Divider(height: 32),
                    actionsButtons(),
                    const SizedBox(height: 12),
                    stacktraceContainer(context, error)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButton(onPressed: () => {}, child: Icon(Icons.replay_outlined)),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () => {}, child: Text('Show error message')),
      ],
    );
  }

  Widget stacktraceContainer(BuildContext context, Object? errorObject) {
    return Container(
      decoration: BoxDecoration(
          color: ColorUtil.darken(Theme.of(context).backgroundColor, 0.05),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      constraints: BoxConstraints(maxHeight: 400),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Text(
            errorObject.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}

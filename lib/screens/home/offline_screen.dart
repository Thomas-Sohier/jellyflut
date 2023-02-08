import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/home/components/error/error_user_actions.dart';
import 'package:jellyflut/screens/home/header_bar.dart';

class OffLineScreen extends StatelessWidget {
  final Object? error;
  final void Function() reloadFunction;
  const OffLineScreen({super.key, required this.error, required this.reloadFunction});

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
                    Icon(iconError, size: 24),
                    const SizedBox(height: 18),
                    Text('You seems to not be able to access your server or to have internet',
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    PaletteButton('Go to my offline library',
                        borderRadius: 4, minHeight: 40, onPressed: () => context.router.root.push(r.DownloadsPage())),
                    Divider(height: 32),
                    ErrorUserActions(
                        reloadFunction: reloadFunction,
                        errorMessage: '${error.toString()}\n${Error.safeToString(error).toString()})')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

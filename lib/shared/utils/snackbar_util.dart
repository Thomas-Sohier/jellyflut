import 'package:flutter/material.dart';
import 'package:jellyflut/theme/theme_extend_own.dart';

/// Helper class that help showing a snackbar.
/// Especially useful to have something similar everywhere on the app
abstract class SnackbarUtil {
  const SnackbarUtil._();

  /// Create a material snackbar to display a message
  /// Can be customized to cahnge depending on the type of message
  ///
  /// On use hide currentSnackbar is there is one
  static void message(
      {required String messageTitle,
      String? messageDetails,
      IconData? icon,
      Duration duration = const Duration(seconds: 7),
      Color? color,
      required BuildContext context}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        // This snackbar has a transparent background so we can add "margin" via he body
        // Snackbar does not permit the use of width and margin property at same time which
        // lead me to cheat a bit
        SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            duration: duration,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            width: 600,
            content: Theme(
              data: Theme.of(context), // context.read<ThemeProvider>().getThemeData,
              child: _CustomSnackbarBody(
                  messageTitle: messageTitle, messageDetails: messageDetails, icon: icon, color: color),
            )),
      );
  }
}

class _CustomSnackbarBody extends StatelessWidget {
  final String messageTitle;
  final String? messageDetails;
  final IconData? icon;
  final Color? color;

  const _CustomSnackbarBody({required this.messageTitle, this.messageDetails, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(messageTitle,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.apply(fontSizeFactor: 1.2)
                                .copyWith(color: ownDetailsTheme(context).onBackground))),
                    messageDetails != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              messageDetails!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: ownDetailsTheme(context).onBackground),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        : const SizedBox()
                  ]),
            ),
            const SizedBox(width: 12),
            icon != null ? Icon(icon, color: color) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

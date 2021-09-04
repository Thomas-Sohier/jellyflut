part of '../buttons.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CancelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: cancelButtonBackground(),
            backgroundColor: cancelButtonBackground(),
            foregroundColor: cancelButtonForeground()),
        child: Text('Cancel', style: TextStyle(fontSize: 18)));
  }
}

part of '../buttons.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: submitButtonBackground(),
            backgroundColor: submitButtonBackground(),
            foregroundColor: submitButtonForeground()),
        child: Text('Submit'));
  }
}

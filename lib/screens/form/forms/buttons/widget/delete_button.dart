part of '../buttons.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: cancelButtonBackground(),
            backgroundColor: cancelButtonBackground(),
            foregroundColor: cancelButtonForeground()),
        child: Text('delete'.tr(), style: TextStyle(fontSize: 18)));
  }
}

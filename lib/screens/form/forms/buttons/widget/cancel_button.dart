part of '../buttons.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CancelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text('cancel'.tr(), style: TextStyle(fontSize: 18)));
  }
}

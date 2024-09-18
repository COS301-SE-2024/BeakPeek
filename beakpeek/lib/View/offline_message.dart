import 'package:flutter/widgets.dart';

class OfflineMessage extends StatelessWidget {
  const OfflineMessage(
      {required this.height,
      required this.width,
      required this.message,
      super.key});
  final double width, height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Text(message),
    );
  }
}

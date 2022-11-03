import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String msg;
  const MessageDisplay({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 50, maxHeight: MediaQuery.of(context).size.height / 3.5),
      child: Center(
          child: Text(
        msg,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )),
    );
  }
}
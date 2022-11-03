import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final Color? color;
  final Decoration? decoration;

  const ButtonWidget({
    Key? key,
    required this.child,
    required this.onTap,
    this.color,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        color: color ?? Colors.blue,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.maxFinite,
            decoration: decoration,
            padding: const EdgeInsets.all(18),
            child: Center(
              child: child
            ),
          ),
        ),
      ),
    );
  }
}

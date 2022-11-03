import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NeonBackgroundScreen extends StatelessWidget {
  final Widget child;
  const NeonBackgroundScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}

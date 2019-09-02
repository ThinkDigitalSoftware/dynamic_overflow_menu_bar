import 'package:flutter/material.dart';

class OverFlowMenuItem extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onPressed;

  OverFlowMenuItem({
    @required this.child,
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class OverFlowMenuItem extends StatefulWidget {
  final Widget child;
  final String label;
  final VoidCallback onPressed;
  Future<Size> get size => _sizeCompleter.future;
  final Completer<Size> _sizeCompleter = Completer();

  OverFlowMenuItem({
    @required this.child,
    @required this.label,
    @required this.onPressed,
  });

  @override
  _OverFlowMenuItemState createState() {
    var overFlowMenuItemState = _OverFlowMenuItemState();
    if (!_sizeCompleter.isCompleted) {
      overFlowMenuItemState.size.then((size) {
        _sizeCompleter.complete(size);
      });
    }
    return overFlowMenuItemState;
  }
}

class _OverFlowMenuItemState extends State<OverFlowMenuItem> {
  Completer<Size> sizeCompleter = Completer();
  final GlobalKey _key = GlobalKey();

  Future<Size> get size {
    return sizeCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      RenderBox _itemBox = _key.currentContext.findRenderObject();
      final Size size = _itemBox.size;
      sizeCompleter.complete(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}

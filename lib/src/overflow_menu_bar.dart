import 'package:dynamic_overflow_menu_bar/src/overflow_menu_item.dart';
import 'package:flutter/material.dart';

/// A widget that can take action buttons and dynamically drop them
/// into an overflow menu based on the available space.
class DynamicOverflowMenuBar extends StatefulWidget {
  final List<OverFlowMenuItem> actions;
  final Widget title;
  DynamicOverflowMenuBar({Key key, @required this.actions, this.title})
      : super(key: key);

  @override
  _DynamicOverflowMenuBarState createState() => _DynamicOverflowMenuBarState();
}

class _DynamicOverflowMenuBarState extends State<DynamicOverflowMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (widget.title != null) widget.title,
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 48),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                int spaceForAvailableButtons =
                    (constraints.maxWidth / 48).floor();
                if (spaceForAvailableButtons < 1) {
                  return ErrorWidget('The available space is too small '
                      'for this widget to be built on the screen.');
                }
                // subtracting 1 if there isn't enough space because the
                // overflow button will count as one.
                int count;
                if (spaceForAvailableButtons < widget.actions.length) {
                  count = spaceForAvailableButtons - 1;
                }
                if (spaceForAvailableButtons == widget.actions.length) {
                  count = spaceForAvailableButtons;
                }
                List<OverFlowMenuItem> visibleWidgets =
                    widget.actions.take(count).toList();
                Iterable<OverFlowMenuItem> remainingActions = [];
                if (widget.actions.length > spaceForAvailableButtons) {
                  remainingActions = widget.actions
                      .getRange(count, widget.actions.length)
                      .toList();
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...visibleWidgets,
                    if (remainingActions.isNotEmpty)
                      PopupMenuButton<OverFlowMenuItem>(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert),
                        onSelected: (item) => item.onPressed(),
                        itemBuilder: (BuildContext context) {
                          return [
                            for (OverFlowMenuItem button in remainingActions)
                              PopupMenuItem(
                                  value: button,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      button,
                                      Text(button.label)
                                    ],
                                  ))
                          ];
                        },
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

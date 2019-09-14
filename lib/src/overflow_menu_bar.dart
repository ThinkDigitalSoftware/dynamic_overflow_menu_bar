import 'package:dynamic_overflow_menu_bar/src/overflow_menu_item.dart';
import 'package:flutter/material.dart';

/// A widget that can take action buttons and dynamically drop them
/// into an overflow menu based on the available space.
class DynamicOverflowMenuBar extends StatefulWidget {
  final List<OverFlowMenuItem> actions;
  final Widget title;
  const DynamicOverflowMenuBar({Key key, @required this.actions, this.title})
      : super(key: key);

  @override
  _DynamicOverflowMenuBarState createState() => _DynamicOverflowMenuBarState();
}

class _DynamicOverflowMenuBarState extends State<DynamicOverflowMenuBar> {
  final overFlowMenuConstraints = BoxConstraints(minWidth: 48);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double titleRowConstraints =
            constraints.maxWidth - overFlowMenuConstraints.minWidth;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.title != null)
              LimitedBox(
                maxWidth: titleRowConstraints,
                child: widget.title,
              ),
            Expanded(
              child: ConstrainedBox(
                constraints: overFlowMenuConstraints,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    debugPrint(
                        'Space available for buttons: ${constraints.maxWidth}');
                    int availableSlots = (constraints.maxWidth / 48).floor();

                    if (availableSlots < 1) {
                      return ErrorWidget('The available space is too small '
                          'for this widget to be built on the screen.');
                    }
                    // subtracting 1 if there isn't enough space because the
                    // overflow button will count as one.
                    int numberOfActionsToShow;
                    if (availableSlots < widget.actions.length) {
                      numberOfActionsToShow = availableSlots - 1;
                    }
                    if (availableSlots == widget.actions.length) {
                      numberOfActionsToShow = availableSlots;
                    }
                    List<OverFlowMenuItem> visibleWidgets =
                        widget.actions.take(numberOfActionsToShow).toList();
                    Iterable<OverFlowMenuItem> remainingActions = [];
                    if (widget.actions.length > availableSlots) {
                      remainingActions = widget.actions
                          .getRange(
                              numberOfActionsToShow, widget.actions.length)
                          .toList();
                    }

                    return OverFlowMenu(
                      visibleWidgets: visibleWidgets,
                      remainingActions: remainingActions,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class OverFlowMenu extends StatelessWidget {
  const OverFlowMenu({
    Key key,
    @required this.visibleWidgets,
    @required this.remainingActions,
  }) : super(key: key);

  final List<OverFlowMenuItem> visibleWidgets;
  final Iterable<OverFlowMenuItem> remainingActions;

  @override
  Widget build(BuildContext context) {
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
                      children: <Widget>[button, Text(button.label)],
                    ),
                  )
              ];
            },
          )
      ],
    );
  }
}

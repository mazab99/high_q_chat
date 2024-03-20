

import 'package:flutter/material.dart';

typedef OnWidgetSizeChange = void Function(bool needToExtend);

/// This widget has been created for size of widget which is covered in view port
/// It also gives update when size changes.
class MeasureSize extends StatefulWidget {
  final Widget? child;
  final OnWidgetSizeChange onSizeChange;

  const MeasureSize({
    Key? key,
    required this.onSizeChange,
    required this.child,
  }) : super(key: key);

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  GlobalKey widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(Duration timestamp) {
    var currentContext = widgetKey.currentContext;
    if (currentContext == null) return;

    var newSize = currentContext.size;
    if (oldSize == newSize) return;
    oldSize = newSize;
    RenderBox? box = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    Offset position = box!.localToGlobal(Offset.zero);

    /// Below logic checks that end position of widget greater than or less than
    /// to device width
    widget.onSizeChange(
        (position.dx + newSize!.width) >= MediaQuery.of(context).size.width);
  }
}

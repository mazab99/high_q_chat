import 'package:flutter/material.dart';
import 'package:high_q_chat/src/models/models.dart';
import 'package:high_q_chat/src/extensions/extensions.dart';

class ChatGroupHeader extends StatelessWidget {
  const ChatGroupHeader({
    Key? key,
    required this.day,
    this.groupSeparatorConfig,
  }) : super(key: key);

  /// Provides day of started chat.
  final DateTime day;

  /// Provides configuration for separator upon date wise chat.
  final DefaultGroupSeparatorConfiguration? groupSeparatorConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: groupSeparatorConfig?.padding ??
          const EdgeInsets.symmetric(vertical: 12),
      child: SelectableText(
        day.getDay,
        cursorColor: Colors.red,
        showCursor: true,
        toolbarOptions: ToolbarOptions(
            copy: true, selectAll: true, cut: false, paste: false),
        textAlign: TextAlign.center,
        style: groupSeparatorConfig?.textStyle ?? const TextStyle(fontSize: 17),
      ),
    );
  }
}

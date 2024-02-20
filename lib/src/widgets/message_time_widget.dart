
import 'package:high_q_chat/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MessageTimeWidget extends StatelessWidget {
  const MessageTimeWidget({
    Key? key,
    required this.messageTime,
    required this.isCurrentUser,
    this.messageTimeTextStyle,
    this.messageTimeIconColor,
  }) : super(key: key);

  /// Provides message crated date time.
  final DateTime messageTime;

  /// Represents message is sending by current user.
  final bool isCurrentUser;

  /// Provides text style of message created time view.
  final TextStyle? messageTimeTextStyle;

  /// Provides color of icon which is showed when user swipe whole chat for
  /// seeing message sending time
  final Color? messageTimeIconColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: messageTimeIconColor ?? Colors.black,
                ),
              ),
              child: Icon(
                isCurrentUser ? Icons.arrow_forward : Icons.arrow_back,
                size: 10,
                color: messageTimeIconColor ?? Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            SelectableText(
              messageTime.getTimeFromDateTime,
              cursorColor: Colors.red,
              showCursor: true,
              toolbarOptions: ToolbarOptions(
                  copy: true, selectAll: true, cut: false, paste: false),
              style: messageTimeTextStyle ?? const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

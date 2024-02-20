
import 'package:flutter/material.dart';

class ReplyIcon extends StatelessWidget {
  const ReplyIcon({
    Key? key,
    required this.scaleAnimation,
    required this.slideAnimation,
    this.replyIconColor,
  }) : super(key: key);

  /// Represents scale animation value of icon when user swipes for reply.
  final Animation<double> scaleAnimation;

  /// Represents slide animation value of chat bubble when user swipes for reply.
  final Animation<Offset> slideAnimation;

  /// Allow user to set color of icon which is appeared when user swipes for reply.
  final Color? replyIconColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: scaleAnimation.value,
          child: CircleAvatar(
            radius: 14,
            backgroundColor:
                scaleAnimation.value == 1.0 ? Colors.grey : Colors.transparent,
            child: Icon(
              Icons.reply_rounded,
              color: replyIconColor ?? Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            value: scaleAnimation.value,
            backgroundColor: Colors.transparent,
            strokeWidth: 1.5,
            color: replyIconColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

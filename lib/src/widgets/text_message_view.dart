
import 'package:high_q_chat/high_q_chat.dart';
import 'package:flutter/material.dart';

import 'package:high_q_chat/src/extensions/extensions.dart';
import 'package:high_q_chat/src/models/models.dart';
import 'package:intl/intl.dart';

import '../utils/constants/constants.dart';
import 'link_preview.dart';
import 'reaction_widget.dart';

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    Key? key,
    required this.isMessageBySender,
    required this.message,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.messageReactionConfig,
    this.highlightMessage = false,
    this.highlightColor,
  }) : super(key: key);

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides message instance of chat.
  final Message message;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents message should highlight.
  final bool highlightMessage;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textMessage = message.message;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: chatBubbleMaxWidth ??
                  MediaQuery.of(context).size.width * 0.75),
          padding: _padding ??
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
          margin: _margin ??
              EdgeInsets.fromLTRB(
                  5, 0, 6, message.reaction.reactions.isNotEmpty ? 15 : 2),
          decoration: BoxDecoration(
            color: highlightMessage ? highlightColor : _color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 70, 5),
                      child: textMessage.isUrl
                          ? LinkPreview(
                              linkPreviewConfig: _linkPreviewConfig,
                              url: textMessage,
                            )
                          : SelectableText(
                              textMessage,
                              cursorColor: Colors.red,
                              showCursor: true,
                              toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                  cut: false,
                                  paste: false),
                              maxLines: null,
                              textAlign: TextAlign.start,
                              style: _textStyle ??
                                  textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: 70,
                  height: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                DateFormat().add_jm().format(message.createdAt),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: _textStyle != null
                                        ? _textStyle!.color ?? Colors.black
                                        : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Icon(
                                message.status == MessageStatus.sent
                                    ? Icons.done
                                    : message.status == MessageStatus.read
                                        ? Icons.done_all_rounded
                                        : message.status ==
                                                MessageStatus.delivered
                                            ? Icons.done_all_rounded
                                            : message.status ==
                                                    MessageStatus.pending
                                                ? Icons.pending
                                                : message.status ==
                                                        MessageStatus
                                                            .undelivered
                                                    ? Icons.error_outline
                                                    : Icons.error_outline,
                                size: 16,
                                color: message.status == MessageStatus.read
                                    ? Colors.lightBlueAccent
                                    : message.status ==
                                            MessageStatus.undelivered
                                        ? Colors.amberAccent
                                        : _textStyle != null
                                            ? _textStyle!.color ?? Colors.black
                                            : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        if (message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            key: key,
            isMessageBySender: isMessageBySender,
            reaction: message.reaction,
            messageReactionConfig: messageReactionConfig,
          ),
      ],
    );
  }

  EdgeInsetsGeometry? get _padding => isMessageBySender
      ? outgoingChatBubbleConfig?.padding
      : inComingChatBubbleConfig?.padding;

  EdgeInsetsGeometry? get _margin => isMessageBySender
      ? outgoingChatBubbleConfig?.margin
      : inComingChatBubbleConfig?.margin;

  LinkPreviewConfiguration? get _linkPreviewConfig => isMessageBySender
      ? outgoingChatBubbleConfig?.linkPreviewConfig
      : inComingChatBubbleConfig?.linkPreviewConfig;

  TextStyle? get _textStyle => isMessageBySender
      ? outgoingChatBubbleConfig?.textStyle
      : inComingChatBubbleConfig?.textStyle;

  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? outgoingChatBubbleConfig?.borderRadius ??
          (message.length < 37
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2))
      : inComingChatBubbleConfig?.borderRadius ??
          (message.length < 29
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2));

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;
}

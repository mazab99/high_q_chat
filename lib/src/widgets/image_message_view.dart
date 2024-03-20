import 'dart:convert';
import 'dart:io';

import 'package:high_q_chat/src/extensions/extensions.dart';
import 'package:high_q_chat/src/models/models.dart';
import 'package:flutter/material.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class ImageMessageView extends StatelessWidget {
  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  String get getImageUrl => message.imageUrl!;

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageMessageConfig?.shareIconConfig,
        imageUrl: getImageUrl,
      );

  Function(Message)? get _onDownloadTap => isMessageBySender
      ? outgoingChatBubbleConfig?.onDownloadTap
      : inComingChatBubbleConfig?.onDownloadTap;

  const ImageMessageView({
    super.key,
    required this.message,
    required this.isMessageBySender,
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender) iconButton,
        Stack(
          children: [
            GestureDetector(
              onTap: () => imageMessageConfig?.onTap != null
                  ? imageMessageConfig?.onTap!(getImageUrl)
                  : null,
              child: Transform.scale(
                scale: highlightImage ? highlightScale : 1.0,
                alignment: isMessageBySender
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: imageMessageConfig?.padding ?? EdgeInsets.zero,
                  margin: imageMessageConfig?.margin ??
                      EdgeInsets.only(
                        top: 6,
                        right: isMessageBySender ? 6 : 0,
                        left: isMessageBySender ? 0 : 6,
                        bottom: message.reaction.reactions.isNotEmpty ? 15 : 0,
                      ),
                  height: imageMessageConfig?.height ?? 200,
                  width: imageMessageConfig?.width ?? 150,
                  child: InkWell(
                    onTap: () {
                      _onDownloadTap!(message) ?? () {};
                    },
                    child: ClipRRect(
                      borderRadius: imageMessageConfig?.borderRadius ??
                          BorderRadius.circular(14),
                      child: (() {
                        if (getImageUrl.isUrl) {
                          return Image.network(
                            getImageUrl,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          );
                        } else if (getImageUrl.fromMemory) {
                          return Image.memory(
                            base64Decode(getImageUrl
                                .substring(getImageUrl.indexOf('base64') + 7)),
                            fit: BoxFit.fill,
                          );
                        } else {
                          return Image.file(
                            File(getImageUrl),
                            fit: BoxFit.fill,
                          );
                        }
                      }()),
                    ),
                  ),
                ),
              ),
            ),
            if (message.reaction.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reaction: message.reaction,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender) iconButton,
      ],
    );
  }
}

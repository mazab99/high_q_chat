
import 'package:high_q_chat/high_q_chat.dart';
import 'package:high_q_chat/src/widgets/chat_list_widget.dart';
import 'package:high_q_chat/src/widgets/high_q_chat_inherited_widget.dart';
import 'package:high_q_chat/src/widgets/high_q_chatstate_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import '../values/custom_time_messages.dart';
import 'send_message_widget.dart';

class HighQChat extends StatefulWidget {
  const HighQChat({
    Key? key,
    required this.chatController,
    required this.currentUser,
    this.onSendTap,
    this.profileCircleConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.replyPopupConfig,
    this.reactionPopupConfig,
    this.loadMoreData,
    this.loadingWidget,
    this.messageConfig,
    this.isLastPage,
    this.appBar,
    ChatBackgroundConfiguration? chatBackgroundConfig,
    this.typeIndicatorConfig,
    this.sendMessageBuilder,
    this.showTypingIndicator = false,
    this.sendMessageConfig,
    required this.highQChatState,
    HighQChatStateConfiguration? highQChatStateConfig,
    this.featureActiveConfig = const FeatureActiveConfig(),
  })  : chatBackgroundConfig =
            chatBackgroundConfig ?? const ChatBackgroundConfiguration(),
        highQChatStateConfig =
            highQChatStateConfig ?? const HighQChatStateConfiguration(),
        super(key: key);

  /// Provides configuration related to user profile circle avatar.
  final ProfileCircleConfiguration? profileCircleConfig;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final StringMessageCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  @Deprecated('Use [ChatController.setTypingIndicator]  instead')

  /// Allow user to show typing indicator.
  final bool showTypingIndicator;

  /// Allow user to giving customisation typing indicator.
  final TypeIndicatorConfiguration? typeIndicatorConfig;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides current state of chat.
  final HighQChatState highQChatState;

  /// Provides configuration for chat view state appearance and functionality.
  final HighQChatStateConfiguration? highQChatStateConfig;

  /// Provides current user which is sending messages.
  final ChatUser currentUser;

  /// Provides configuration for turn on/off specific features.
  final FeatureActiveConfig featureActiveConfig;

  /// Provides parameter so user can assign HighQChatAppbar.
  final Widget? appBar;

  @override
  State<HighQChat> createState() => _HighQChatState();
}

class _HighQChatState extends State<HighQChat>
    with SingleTickerProviderStateMixin {
  final GlobalKey<SendMessageWidgetState> _sendMessageKey = GlobalKey();
  ValueNotifier<ReplyMessage> replyMessage =
      ValueNotifier(const ReplyMessage());

  ChatController get chatController => widget.chatController;

  // bool get showTypingIndicator => widget.showTypingIndicator;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  HighQChatState get highQChatState => widget.highQChatState;

  HighQChatStateConfiguration? get highQChatStateConfig =>
      widget.highQChatStateConfig;

  FeatureActiveConfig get featureActiveConfig => widget.featureActiveConfig;

  @override
  void initState() {
    super.initState();
    setLocaleMessages('en', ReceiptsCustomMessages());
    // Adds current user in users list.
    chatController.chatUsers.add(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to last message on in hasMessages state.
    // TODO: Remove this in new versions.
    // ignore: deprecated_member_use_from_same_package
    if (widget.showTypingIndicator ||
        widget.chatController.showTypingIndicator &&
            highQChatState.hasMessages) {
      chatController.scrollToLastMessage();
    }
    return HighQChatInheritedWidget(
      chatController: chatController,
      featureActiveConfig: featureActiveConfig,
      currentUser: widget.currentUser,
      child: Container(
        height:
            chatBackgroundConfig.height ?? MediaQuery.of(context).size.height,
        width: chatBackgroundConfig.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: chatBackgroundConfig.backgroundColor ?? Colors.white,
          image: chatBackgroundConfig.backgroundImage != null
              ? DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(chatBackgroundConfig.backgroundImage!),
                )
              : null,
        ),
        padding: chatBackgroundConfig.padding,
        margin: chatBackgroundConfig.margin,
        child: Column(
          children: [
            if (widget.appBar != null) widget.appBar!,
            Expanded(
              child: Stack(
                children: [
                  if (highQChatState.isLoading)
                    HighQChatStateWidget(
                      highQChatStateWidgetConfig:
                          highQChatStateConfig?.loadingWidgetConfig,
                      highQChatState: highQChatState,
                    )
                  else if (highQChatState.noMessages)
                    HighQChatStateWidget(
                      highQChatStateWidgetConfig:
                          highQChatStateConfig?.noMessageWidgetConfig,
                      highQChatState: highQChatState,
                      onReloadButtonTap: highQChatStateConfig?.onReloadButtonTap,
                    )
                  else if (highQChatState.isError)
                    HighQChatStateWidget(
                      highQChatStateWidgetConfig:
                          highQChatStateConfig?.errorWidgetConfig,
                      highQChatState: highQChatState,
                      onReloadButtonTap: highQChatStateConfig?.onReloadButtonTap,
                    )
                  else if (highQChatState.hasMessages)
                    ValueListenableBuilder<ReplyMessage>(
                      valueListenable: replyMessage,
                      builder: (_, state, child) {
                        return ChatListWidget(
                          /// TODO: Remove this in future releases.
                          // ignore: deprecated_member_use_from_same_package
                          showTypingIndicator: widget.showTypingIndicator,
                          replyMessage: state,
                          chatController: widget.chatController,
                          chatBackgroundConfig: widget.chatBackgroundConfig,
                          reactionPopupConfig: widget.reactionPopupConfig,
                          typeIndicatorConfig: widget.typeIndicatorConfig,
                          chatBubbleConfig: widget.chatBubbleConfig,
                          loadMoreData: widget.loadMoreData,
                          isLastPage: widget.isLastPage,
                          replyPopupConfig: widget.replyPopupConfig,
                          loadingWidget: widget.loadingWidget,
                          messageConfig: widget.messageConfig,
                          profileCircleConfig: widget.profileCircleConfig,
                          repliedMessageConfig: widget.repliedMessageConfig,
                          swipeToReplyConfig: widget.swipeToReplyConfig,
                          assignReplyMessage: (message) => _sendMessageKey
                              .currentState
                              ?.assignReplyMessage(message),
                        );
                      },
                    ),
                  if (featureActiveConfig.enableTextField)
                    SendMessageWidget(
                      key: _sendMessageKey,
                      chatController: chatController,
                      sendMessageBuilder: widget.sendMessageBuilder,
                      sendMessageConfig: widget.sendMessageConfig,
                      backgroundColor: chatBackgroundConfig.backgroundColor,
                      onSendTap: _onSendTap,
                      onReplyCallback: (reply) => replyMessage.value = reply,
                      onReplyCloseCallback: () =>
                          replyMessage.value = const ReplyMessage(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    if (widget.sendMessageBuilder == null) {
      if (widget.onSendTap != null) {
        widget.onSendTap!(message, replyMessage, messageType);
      }
      _assignReplyMessage();
    }
    chatController.scrollToLastMessage();
  }

  void _assignReplyMessage() {
    if (replyMessage.value.message.isNotEmpty) {
      replyMessage.value = const ReplyMessage();
    }
  }

  @override
  void dispose() {
    replyMessage.dispose();
    super.dispose();
  }
}

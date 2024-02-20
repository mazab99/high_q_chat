import 'package:flutter/material.dart';
import 'package:high_q_chat/high_q_chat.dart';

class HighQChatInheritedWidget extends InheritedWidget {
  const HighQChatInheritedWidget({
    Key? key,
    required Widget child,
    required this.featureActiveConfig,
    required this.chatController,
    required this.currentUser,
  }) : super(key: key, child: child);
  final FeatureActiveConfig featureActiveConfig;
  final ChatController chatController;
  final ChatUser currentUser;

  static HighQChatInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HighQChatInheritedWidget>();

  @override
  bool updateShouldNotify(covariant HighQChatInheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}

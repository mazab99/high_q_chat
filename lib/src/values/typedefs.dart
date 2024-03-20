import 'package:high_q_chat/high_q_chat.dart';
import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);
typedef StringMessageCallBack = void Function(
  String message,
  ReplyMessage replyMessage,
  MessageType messageType,
);
typedef ReplyMessageWithReturnWidget = Widget Function(
  ReplyMessage? replyMessage,
);
typedef ReplyMessageCallBack = void Function(ReplyMessage replyMessage);
typedef VoidCallBack = void Function();
typedef DoubleCallBack = void Function(double, double);
typedef MessageCallBack = void Function(Message message);
typedef VoidCallBackWithFuture = Future<void> Function();
typedef StringsCallBack = void Function(String emoji, String messageId);
typedef StringWithReturnWidget = Widget Function(String separator);
typedef DragUpdateDetailsCallback = void Function(DragUpdateDetails);

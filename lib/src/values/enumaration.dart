

// Different types Message of HighQChat
enum MessageType {
  file,
  image,
  text,
  textAndImage,

  /// Only supported on android and ios
  voice,
  custom
}

/// Events, Wheter the user is still typing a message or has
/// typed the message
enum TypeWriterStatus { typing, typed }

/// [MessageStatus] defines the current state of the message
/// if you are sender sending a message then, the
enum MessageStatus { sent, read, delivered, undelivered, pending }

/// Types of states
enum HighQChatState { hasMessages, noData, loading, error }

enum ShowReceiptsIn { all, lastMessage }

extension HighQChatStateExtension on HighQChatState {
  bool get hasMessages => this == HighQChatState.hasMessages;

  bool get isLoading => this == HighQChatState.loading;

  bool get isError => this == HighQChatState.error;

  bool get noMessages => this == HighQChatState.noData;
}

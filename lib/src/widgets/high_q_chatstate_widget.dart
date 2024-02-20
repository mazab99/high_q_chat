import 'package:high_q_chat/high_q_chat.dart';
import 'package:high_q_chat/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class HighQChatStateWidget extends StatelessWidget {
  const HighQChatStateWidget({
    Key? key,
    this.highQChatStateWidgetConfig,
    required this.highQChatState,
    this.onReloadButtonTap,
  }) : super(key: key);

  /// Provides configuration of chat view's different states such as text styles,
  /// widgets and etc.
  final HighQChatStateWidgetConfiguration? highQChatStateWidgetConfig;

  /// Provides current state of chat view.
  final HighQChatState highQChatState;

  /// Provides callback when user taps on reload button in error and no messages
  /// state.
  final VoidCallBack? onReloadButtonTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: highQChatStateWidgetConfig?.widget ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText(
                (highQChatStateWidgetConfig?.title
                    .getHighQChatStateTitle(highQChatState))!,
                cursorColor: Colors.red,
                showCursor: true,
                toolbarOptions: ToolbarOptions(
                    copy: true, selectAll: true, cut: false, paste: false),
                style: highQChatStateWidgetConfig?.titleTextStyle ??
                    const TextStyle(
                      fontSize: 22,
                    ),
              ),
              if (highQChatStateWidgetConfig?.subTitle != null)
                SelectableText(
                  (highQChatStateWidgetConfig?.subTitle)!,
                  cursorColor: Colors.red,
                  showCursor: true,
                  toolbarOptions: ToolbarOptions(
                      copy: true, selectAll: true, cut: false, paste: false),
                  style: highQChatStateWidgetConfig?.subTitleTextStyle,
                ),
              if (highQChatState.isLoading)
                CircularProgressIndicator(
                  color: highQChatStateWidgetConfig?.loadingIndicatorColor,
                ),
              if (highQChatStateWidgetConfig?.imageWidget != null)
                (highQChatStateWidgetConfig?.imageWidget)!,
              if (highQChatStateWidgetConfig?.reloadButton != null)
                (highQChatStateWidgetConfig?.reloadButton)!,
              if (highQChatStateWidgetConfig != null &&
                  (highQChatStateWidgetConfig?.showDefaultReloadButton)! &&
                  highQChatStateWidgetConfig?.reloadButton == null &&
                  (highQChatState.isError || highQChatState.noMessages)) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onReloadButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        highQChatStateWidgetConfig?.reloadButtonColor ??
                            const Color(0xffEE5366),
                  ),
                  child: const SelectableText(
                    'Reload',
                    cursorColor: Colors.red,
                    showCursor: true,
                    toolbarOptions: ToolbarOptions(
                        copy: true, selectAll: true, cut: false, paste: false),
                  ),
                )
              ]
            ],
          ),
    );
  }
}

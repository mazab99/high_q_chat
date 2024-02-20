
import 'package:flutter/material.dart';
import 'package:high_q_chat/src/models/reaction_popup_configuration.dart';
import 'package:high_q_chat/src/utils/constants/constants.dart';

import '../values/typedefs.dart';
import 'emoji_picker_widget.dart';

class EmojiRow extends StatelessWidget {
  EmojiRow({
    Key? key,
    required this.onEmojiTap,
    this.emojiConfiguration,
  }) : super(key: key);

  /// Provides callback when user taps on emoji in reaction pop-up.
  final StringCallback onEmojiTap;

  /// Provides configuration of emoji's appearance in reaction pop-up.
  final EmojiConfiguration? emojiConfiguration;

  /// These are default emojis.
  final List<String> _emojiUnicodes = [
    heart,
    faceWithTears,
    astonishedFace,
    disappointedFace,
    angryFace,
    thumbsUp,
  ];

  @override
  Widget build(BuildContext context) {
    final emojiList = emojiConfiguration?.emojiList ?? _emojiUnicodes;
    final size = emojiConfiguration?.size;
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              emojiList.length,
              (index) => GestureDetector(
                onTap: () => onEmojiTap(emojiList[index]),
                child: Text(
                  emojiList[index],
                  style: TextStyle(fontSize: size ?? 28),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.add,
            color: Colors.grey.shade600,
            size: size ?? 28,
          ),
          onPressed: () => _showBottomSheet(context),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        builder: (context) => EmojiPickerWidget(onSelected: (emoji) {
          Navigator.pop(context);
          onEmojiTap(emoji);
        }),
      );
}

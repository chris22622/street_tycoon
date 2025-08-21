import 'package:flutter/material.dart';
import '../../data/character_models.dart';
import 'character_avatar_ultra_realistic.dart';

class CharacterAvatarWidget extends StatelessWidget {
  final CharacterAppearance character;
  final double size;
  final bool showBorder;

  const CharacterAvatarWidget({
    super.key,
    required this.character,
    this.size = 60,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return UltraRealisticCharacterAvatar(
      character: character,
      size: size,
      showBorder: showBorder,
    );
  }
}

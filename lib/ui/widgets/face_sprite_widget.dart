import 'package:flutter/material.dart';

enum FaceCategory {
  diverse, styles, extras, black, asian, hispanic;
  String get displayName {
    switch (this) {
      case diverse: return 'Diverse';
      case styles: return 'Hairstyles';
      case extras: return 'Accessories';
      case black: return 'Black';
      case asian: return 'Asian';
      case hispanic: return 'Hispanic';
    }
  }
  String get assetPath {
    switch (this) {
      case diverse: return 'assets/faces/faces_diverse.png';
      case styles: return 'assets/faces/faces_styles.png';
      case extras: return 'assets/faces/faces_extras.png';
      case black: return 'assets/faces/faces_black.png';
      case asian: return 'assets/faces/faces_asian.png';
      case hispanic: return 'assets/faces/faces_hispanic.png';
    }
  }
  IconData get icon {
    switch (this) {
      case diverse: return Icons.people;
      case styles: return Icons.content_cut;
      case extras: return Icons.auto_awesome;
      case black: return Icons.face;
      case asian: return Icons.face_2;
      case hispanic: return Icons.face_3;
    }
  }
}

class FaceSelection {
  final FaceCategory category;
  final int row;
  final int col;
  const FaceSelection({required this.category, required this.row, required this.col});
  int get faceIndex => row * 4 + col;
  String get id => '\${category.name}_\${row}_\$col';
  Map<String, dynamic> toJson() => {'category': category.name, 'row': row, 'col': col};
  factory FaceSelection.fromJson(Map<String, dynamic> json) {
    return FaceSelection(
      category: FaceCategory.values.firstWhere((c) => c.name == json['category'], orElse: () => FaceCategory.diverse),
      row: json['row'] ?? 0,
      col: json['col'] ?? 0,
    );
  }
  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceSelection && category == other.category && row == other.row && col == other.col;
  @override
  int get hashCode => Object.hash(category, row, col);
}

class FaceSpriteWidget extends StatelessWidget {
  final FaceSelection face;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;
  const FaceSpriteWidget({super.key, required this.face, this.size = 80, this.isSelected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size, height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 9 : 12),
          child: FaceClipWidget(assetPath: face.category.assetPath, row: face.row, col: face.col),
        ),
      ),
    );
  }
}

class FaceClipWidget extends StatelessWidget {
  final String assetPath;
  final int row;
  final int col;
  const FaceClipWidget({super.key, required this.assetPath, required this.row, required this.col});
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 100, height: 100,
        child: OverflowBox(
          maxWidth: 400, maxHeight: 400,
          alignment: Alignment(-1.0 + (col * 2.0 / 3.0), -1.0 + (row * 2.0 / 3.0)),
          child: Image.asset(assetPath, width: 400, height: 400, fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) => Container(color: Colors.grey[800], child: const Center(child: Icon(Icons.face, color: Colors.white54, size: 40))),
          ),
        ),
      ),
    );
  }
}

class FaceAvatarDisplay extends StatelessWidget {
  final FaceSelection? face;
  final double size;
  const FaceAvatarDisplay({super.key, this.face, this.size = 160});
  @override
  Widget build(BuildContext context) {
    if (face == null) {
      return Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[800], border: Border.all(color: Colors.amber, width: 3)),
        child: Icon(Icons.person_add, size: size * 0.4, color: Colors.white54),
      );
    }
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.amber, width: 3),
        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)],
      ),
      child: ClipOval(child: FaceClipWidget(assetPath: face!.category.assetPath, row: face!.row, col: face!.col)),
    );
  }
}

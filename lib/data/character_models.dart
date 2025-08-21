enum Gender {
  male,
  female,
  nonBinary,
}

enum Ethnicity {
  african,
  asian,
  caucasian,
  hispanic,
  middleEastern,
  nativeAmerican,
  mixed,
}

enum SkinTone {
  veryLight,
  light,
  medium,
  tan,
  dark,
  veryDark,
}

enum HairColor {
  black,
  brown,
  blonde,
  red,
  gray,
  white,
  blue,
  green,
  purple,
  pink,
}

enum HairStyle {
  short,
  medium,
  long,
  curly,
  wavy,
  straight,
  buzz,
  mohawk,
  dreadlocks,
  bald,
}

enum FaceShape {
  oval,
  round,
  square,
  heart,
  diamond,
  oblong,
}

enum EyeColor {
  brown,
  blue,
  green,
  hazel,
  gray,
  amber,
  violet,
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.nonBinary:
        return 'Non-Binary';
    }
  }

  String get emoji {
    switch (this) {
      case Gender.male:
        return '♂️';
      case Gender.female:
        return '♀️';
      case Gender.nonBinary:
        return '⚧️';
    }
  }

  List<String> get pronouns {
    switch (this) {
      case Gender.male:
        return ['he', 'him', 'his'];
      case Gender.female:
        return ['she', 'her', 'hers'];
      case Gender.nonBinary:
        return ['they', 'them', 'theirs'];
    }
  }
}

extension EthnicityExtension on Ethnicity {
  String get displayName {
    switch (this) {
      case Ethnicity.african:
        return 'African/Black';
      case Ethnicity.asian:
        return 'Asian';
      case Ethnicity.caucasian:
        return 'Caucasian/White';
      case Ethnicity.hispanic:
        return 'Hispanic/Latino';
      case Ethnicity.middleEastern:
        return 'Middle Eastern';
      case Ethnicity.nativeAmerican:
        return 'Native American';
      case Ethnicity.mixed:
        return 'Mixed/Other';
    }
  }
}

extension SkinToneExtension on SkinTone {
  String get displayName {
    switch (this) {
      case SkinTone.veryLight:
        return 'Very Light';
      case SkinTone.light:
        return 'Light';
      case SkinTone.medium:
        return 'Medium';
      case SkinTone.tan:
        return 'Tan';
      case SkinTone.dark:
        return 'Dark';
      case SkinTone.veryDark:
        return 'Very Dark';
    }
  }

  String get colorHex {
    switch (this) {
      case SkinTone.veryLight:
        return '#FDBCB4';
      case SkinTone.light:
        return '#EEA990';
      case SkinTone.medium:
        return '#C68642';
      case SkinTone.tan:
        return '#A0522D';
      case SkinTone.dark:
        return '#8B4513';
      case SkinTone.veryDark:
        return '#654321';
    }
  }
}

extension HairColorExtension on HairColor {
  String get displayName {
    switch (this) {
      case HairColor.black:
        return 'Black';
      case HairColor.brown:
        return 'Brown';
      case HairColor.blonde:
        return 'Blonde';
      case HairColor.red:
        return 'Red';
      case HairColor.gray:
        return 'Gray';
      case HairColor.white:
        return 'White';
      case HairColor.blue:
        return 'Blue';
      case HairColor.green:
        return 'Green';
      case HairColor.purple:
        return 'Purple';
      case HairColor.pink:
        return 'Pink';
    }
  }

  String get colorHex {
    switch (this) {
      case HairColor.black:
        return '#000000';
      case HairColor.brown:
        return '#8B4513';
      case HairColor.blonde:
        return '#FFD700';
      case HairColor.red:
        return '#DC143C';
      case HairColor.gray:
        return '#808080';
      case HairColor.white:
        return '#FFFFFF';
      case HairColor.blue:
        return '#0000FF';
      case HairColor.green:
        return '#008000';
      case HairColor.purple:
        return '#800080';
      case HairColor.pink:
        return '#FFC0CB';
    }
  }
}

extension HairStyleExtension on HairStyle {
  String get displayName {
    switch (this) {
      case HairStyle.short:
        return 'Short';
      case HairStyle.medium:
        return 'Medium';
      case HairStyle.long:
        return 'Long';
      case HairStyle.curly:
        return 'Curly';
      case HairStyle.wavy:
        return 'Wavy';
      case HairStyle.straight:
        return 'Straight';
      case HairStyle.buzz:
        return 'Buzz Cut';
      case HairStyle.mohawk:
        return 'Mohawk';
      case HairStyle.dreadlocks:
        return 'Dreadlocks';
      case HairStyle.bald:
        return 'Bald';
    }
  }
}

extension FaceShapeExtension on FaceShape {
  String get displayName {
    switch (this) {
      case FaceShape.oval:
        return 'Oval';
      case FaceShape.round:
        return 'Round';
      case FaceShape.square:
        return 'Square';
      case FaceShape.heart:
        return 'Heart';
      case FaceShape.diamond:
        return 'Diamond';
      case FaceShape.oblong:
        return 'Oblong';
    }
  }
}

extension EyeColorExtension on EyeColor {
  String get displayName {
    switch (this) {
      case EyeColor.brown:
        return 'Brown';
      case EyeColor.blue:
        return 'Blue';
      case EyeColor.green:
        return 'Green';
      case EyeColor.hazel:
        return 'Hazel';
      case EyeColor.gray:
        return 'Gray';
      case EyeColor.amber:
        return 'Amber';
      case EyeColor.violet:
        return 'Violet';
    }
  }

  String get colorHex {
    switch (this) {
      case EyeColor.brown:
        return '#8B4513';
      case EyeColor.blue:
        return '#0000FF';
      case EyeColor.green:
        return '#008000';
      case EyeColor.hazel:
        return '#8E7618';
      case EyeColor.gray:
        return '#808080';
      case EyeColor.amber:
        return '#FFBF00';
      case EyeColor.violet:
        return '#8B00FF';
    }
  }
}

class CharacterAppearance {
  final String firstName;
  final String lastName;
  final Gender gender;
  final Ethnicity ethnicity;
  final SkinTone skinTone;
  final HairColor hairColor;
  final HairStyle hairStyle;
  final FaceShape faceShape;
  final EyeColor eyeColor;
  final int age;
  final String backstory;

  const CharacterAppearance({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.ethnicity,
    required this.skinTone,
    required this.hairColor,
    required this.hairStyle,
    required this.faceShape,
    required this.eyeColor,
    this.age = 25,
    this.backstory = '',
  });

  String get fullName => '$firstName $lastName';

  String get displayDescription {
    return '${age}-year-old ${gender.displayName.toLowerCase()} with ${skinTone.displayName.toLowerCase()} skin, ${hairColor.displayName.toLowerCase()} ${hairStyle.displayName.toLowerCase()} hair, and ${eyeColor.displayName.toLowerCase()} eyes';
  }

  CharacterAppearance copyWith({
    String? firstName,
    String? lastName,
    Gender? gender,
    Ethnicity? ethnicity,
    SkinTone? skinTone,
    HairColor? hairColor,
    HairStyle? hairStyle,
    FaceShape? faceShape,
    EyeColor? eyeColor,
    int? age,
    String? backstory,
  }) {
    return CharacterAppearance(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      ethnicity: ethnicity ?? this.ethnicity,
      skinTone: skinTone ?? this.skinTone,
      hairColor: hairColor ?? this.hairColor,
      hairStyle: hairStyle ?? this.hairStyle,
      faceShape: faceShape ?? this.faceShape,
      eyeColor: eyeColor ?? this.eyeColor,
      age: age ?? this.age,
      backstory: backstory ?? this.backstory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.index,
      'ethnicity': ethnicity.index,
      'skinTone': skinTone.index,
      'hairColor': hairColor.index,
      'hairStyle': hairStyle.index,
      'faceShape': faceShape.index,
      'eyeColor': eyeColor.index,
      'age': age,
      'backstory': backstory,
    };
  }

  factory CharacterAppearance.fromJson(Map<String, dynamic> json) {
    return CharacterAppearance(
      firstName: json['firstName'] ?? 'John',
      lastName: json['lastName'] ?? 'Doe',
      gender: Gender.values[json['gender'] ?? 0],
      ethnicity: Ethnicity.values[json['ethnicity'] ?? 0],
      skinTone: SkinTone.values[json['skinTone'] ?? 0],
      hairColor: HairColor.values[json['hairColor'] ?? 0],
      hairStyle: HairStyle.values[json['hairStyle'] ?? 0],
      faceShape: FaceShape.values[json['faceShape'] ?? 0],
      eyeColor: EyeColor.values[json['eyeColor'] ?? 0],
      age: json['age'] ?? 25,
      backstory: json['backstory'] ?? '',
    );
  }

  static CharacterAppearance defaultCharacter() {
    return const CharacterAppearance(
      firstName: 'John',
      lastName: 'Doe',
      gender: Gender.male,
      ethnicity: Ethnicity.caucasian,
      skinTone: SkinTone.medium,
      hairColor: HairColor.brown,
      hairStyle: HairStyle.short,
      faceShape: FaceShape.oval,
      eyeColor: EyeColor.brown,
      age: 25,
      backstory: 'A newcomer to the streets looking to make it big.',
    );
  }
}

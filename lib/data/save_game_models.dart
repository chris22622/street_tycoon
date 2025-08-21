import 'models.dart';
import 'character_models.dart';

class SaveGameData {
  final String id;
  final String characterName;
  final CharacterAppearance character;
  final GameState gameState;
  final DateTime lastPlayed;
  final DateTime created;

  SaveGameData({
    required this.id,
    required this.characterName,
    required this.character,
    required this.gameState,
    required this.lastPlayed,
    required this.created,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterName': characterName,
      'character': character.toJson(),
      'gameState': gameState.toJson(),
      'lastPlayed': lastPlayed.toIso8601String(),
      'created': created.toIso8601String(),
    };
  }

  factory SaveGameData.fromJson(Map<String, dynamic> json) {
    return SaveGameData(
      id: json['id'],
      characterName: json['characterName'],
      character: CharacterAppearance.fromJson(json['character']),
      gameState: GameState.fromJson(json['gameState']),
      lastPlayed: DateTime.parse(json['lastPlayed']),
      created: DateTime.parse(json['created']),
    );
  }

  SaveGameData copyWith({
    String? id,
    String? characterName,
    CharacterAppearance? character,
    GameState? gameState,
    DateTime? lastPlayed,
    DateTime? created,
  }) {
    return SaveGameData(
      id: id ?? this.id,
      characterName: characterName ?? this.characterName,
      character: character ?? this.character,
      gameState: gameState ?? this.gameState,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      created: created ?? this.created,
    );
  }

  String get displayName => '${character.firstName} ${character.lastName}';
  String get saveFileName => 'save_$id.json';
}

class SaveGameList {
  final List<SaveGameData> saves;

  SaveGameList({required this.saves});

  Map<String, dynamic> toJson() {
    return {
      'saves': saves.map((save) => save.toJson()).toList(),
    };
  }

  factory SaveGameList.fromJson(Map<String, dynamic> json) {
    return SaveGameList(
      saves: (json['saves'] as List)
          .map((saveJson) => SaveGameData.fromJson(saveJson))
          .toList(),
    );
  }

  SaveGameList copyWith({List<SaveGameData>? saves}) {
    return SaveGameList(saves: saves ?? this.saves);
  }

  SaveGameList addSave(SaveGameData save) {
    final newSaves = List<SaveGameData>.from(saves);
    newSaves.add(save);
    newSaves.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
    return SaveGameList(saves: newSaves);
  }

  SaveGameList removeSave(String id) {
    final newSaves = saves.where((save) => save.id != id).toList();
    return SaveGameList(saves: newSaves);
  }

  SaveGameList updateSave(SaveGameData updatedSave) {
    final newSaves = saves.map((save) => 
        save.id == updatedSave.id ? updatedSave : save).toList();
    newSaves.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
    return SaveGameList(saves: newSaves);
  }

  SaveGameData? findById(String id) {
    try {
      return saves.firstWhere((save) => save.id == id);
    } catch (e) {
      return null;
    }
  }

  bool get isEmpty => saves.isEmpty;
  bool get isNotEmpty => saves.isNotEmpty;
  int get length => saves.length;
}

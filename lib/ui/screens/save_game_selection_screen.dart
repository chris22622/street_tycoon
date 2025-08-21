import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/save_game_models.dart';
import '../../data/storage.dart';
import '../../data/character_models.dart';
import '../widgets/character_avatar_widget.dart';

class SaveGameSelectionScreen extends ConsumerStatefulWidget {
  const SaveGameSelectionScreen({super.key});

  @override
  ConsumerState<SaveGameSelectionScreen> createState() => _SaveGameSelectionScreenState();
}

class _SaveGameSelectionScreenState extends ConsumerState<SaveGameSelectionScreen> {
  SaveGameList? saveGameList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaveGames();
  }

  Future<void> _loadSaveGames() async {
    setState(() => isLoading = true);
    
    try {
      // Try to migrate legacy saves first
      await SharedPrefsStorage.migrateLegacySave();
      
      final saves = await SharedPrefsStorage.loadSaveGameList();
      setState(() {
        saveGameList = saves;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading saves: $e')),
        );
      }
    }
  }

  Future<void> _loadGame(SaveGameData saveData) async {
    try {
      setState(() => isLoading = true);
      
      // Update last played time
      final updatedSave = saveData.copyWith(lastPlayed: DateTime.now());
      await SharedPrefsStorage.saveSaveGame(updatedSave);
      
      // Navigate to game
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading game: $e')),
        );
      }
    }
  }

  Future<void> _deleteGame(SaveGameData saveData) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Save Game'),
        content: Text('Are you sure you want to delete "${saveData.displayName}"?\n\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SharedPrefsStorage.deleteSaveGame(saveData.id);
        await _loadSaveGames(); // Refresh the list
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Save game deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting save: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Select Character', style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            onPressed: () => context.go('/character-creation'),
            icon: const Icon(Icons.add),
            tooltip: 'New Character',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (saveGameList == null || saveGameList!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'No Characters Found',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first character to start playing',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/character-creation'),
              icon: const Icon(Icons.add),
              label: const Text('Create Character'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/character-creation'),
                  icon: const Icon(Icons.add),
                  label: const Text('New Character'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: saveGameList!.saves.length,
            itemBuilder: (context, index) {
              final save = saveGameList!.saves[index];
              return _SaveGameCard(
                saveData: save,
                onLoad: () => _loadGame(save),
                onDelete: () => _deleteGame(save),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SaveGameCard extends StatelessWidget {
  final SaveGameData saveData;
  final VoidCallback onLoad;
  final VoidCallback onDelete;

  const _SaveGameCard({
    required this.saveData,
    required this.onLoad,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = saveData.gameState;
    final character = saveData.character;
    
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onLoad,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Character Avatar
              CharacterAvatarWidget(
                character: character,
                size: 80,
                showBorder: true,
              ),
              
              const SizedBox(width: 16),
              
              // Character Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saveData.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${character.gender.displayName} • ${character.ethnicity.displayName}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 16, color: Colors.green[400]),
                        Text(
                          '\$${(gameState.cash + gameState.bank).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(color: Colors.green[400], fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.calendar_today, size: 16, color: Colors.blue[400]),
                        Text(
                          'Day ${gameState.day}',
                          style: TextStyle(color: Colors.blue[400], fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last played: ${_formatDate(saveData.lastPlayed)}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Column(
                children: [
                  IconButton(
                    onPressed: onLoad,
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    tooltip: 'Load Game',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

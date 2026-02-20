import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/face_sprite_widget.dart';
import '../../data/character_models.dart';

class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});
  @override
  ConsumerState<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends ConsumerState<CharacterCreationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FaceSelection _selectedFace = FaceSelection(category: FaceCategory.diverse, row: 0, col: 0);
  Gender _selectedGender = Gender.male;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FaceCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create Character', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: _currentStep == 0 ? _buildFaceSelection() : _buildNameEntry(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFaceSelection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        FaceAvatarDisplay(face: _selectedFace, size: 100),
        const SizedBox(height: 8),
        const Text('Choose Your Face', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.amber,
          tabs: FaceCategory.values.map((c) => Tab(text: c.displayName)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: FaceCategory.values.map((category) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (ctx, index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  final face = FaceSelection(category: category, row: row, col: col);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFace = face),
                    child: FaceSpriteWidget(
                      face: face,
                      size: 70,
                      isSelected: _selectedFace == face,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNameEntry() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          FaceAvatarDisplay(face: _selectedFace, size: 120),
          const SizedBox(height: 24),
          TextField(
            controller: _firstNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'First Name',
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Gender', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: Gender.values.map((g) {
              return ChoiceChip(
                label: Text(g.displayName),
                selected: _selectedGender == g,
                selectedColor: Colors.amber,
                labelStyle: TextStyle(color: _selectedGender == g ? Colors.black : Colors.white),
                backgroundColor: Colors.grey[800],
                onSelected: (_) => setState(() => _selectedGender = g),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const Text('Back', style: TextStyle(color: Colors.grey)),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: _currentStep == 0 ? () => setState(() => _currentStep = 1) : _createCharacter,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(_currentStep == 0 ? 'Next' : 'Start Game', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _createCharacter() {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a first name'), backgroundColor: Colors.red));
      return;
    }
    // Navigate to dashboard with character created
    context.go('/dashboard');
  }
}

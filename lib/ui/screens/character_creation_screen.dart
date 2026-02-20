import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/face_sprite_widget.dart';
import '../../data/character_models.dart';
import '../../theme/app_theme.dart';

class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  ConsumerState<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState
    extends ConsumerState<CharacterCreationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FaceSelection _selectedFace =
      FaceSelection(category: FaceCategory.diverse, row: 0, col: 0);
  Gender _selectedGender = Gender.male;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FaceCategory.values.length, vsync: this);
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
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text('Create Your Character',
            style: AppTheme.heading.copyWith(fontSize: 20)),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: _currentStep == 0
                ? _buildFaceSelection()
                : _buildNameEntry(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      color: AppTheme.surface,
      child: Row(
        children: [
          _buildStepDot(0, 'Appearance'),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 1 ? AppTheme.gold : Colors.white24,
            ),
          ),
          _buildStepDot(1, 'Identity'),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.gold : AppTheme.surfaceLight,
            border: Border.all(
              color: isActive ? AppTheme.gold : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: isActive
                ? Icon(
                    step < _currentStep ? Icons.check : Icons.circle,
                    size: 14,
                    color: AppTheme.bg,
                  )
                : Text('${step + 1}',
                    style: AppTheme.body.copyWith(fontSize: 12)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: AppTheme.body.copyWith(
              fontSize: 11,
              color: isActive ? AppTheme.gold : Colors.white54,
            )),
      ],
    );
  }

  Widget _buildFaceSelection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.gold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withOpacity(0.3),
                blurRadius: 16,
              ),
            ],
          ),
          child: FaceAvatarDisplay(face: _selectedFace, size: 90),
        ),
        const SizedBox(height: 12),
        Text('Choose Your Look',
            style: AppTheme.heading.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.gold,
          unselectedLabelColor: Colors.white54,
          indicatorColor: AppTheme.gold,
          indicatorWeight: 3,
          tabs: FaceCategory.values
              .map((c) => Tab(text: c.displayName))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: FaceCategory.values.map((category) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (ctx, index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  final face = FaceSelection(
                      category: category, row: row, col: col);
                  final isSelected = _selectedFace == face;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFace = face),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.gold
                              : Colors.white12,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.gold.withOpacity(0.3),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: FaceSpriteWidget(
                        face: face,
                        size: 64,
                        isSelected: isSelected,
                      ),
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
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gold.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: FaceAvatarDisplay(face: _selectedFace, size: 100),
          ),
          const SizedBox(height: 24),
          Text('Who Are You?',
              style: AppTheme.heading.copyWith(fontSize: 22)),
          const SizedBox(height: 24),
          _buildTextField(_firstNameController, 'First Name'),
          const SizedBox(height: 16),
          _buildTextField(_lastNameController, 'Last Name'),
          const SizedBox(height: 24),
          Text('Gender', style: AppTheme.heading.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: Gender.values.map((g) {
              final isSelected = _selectedGender == g;
              return ChoiceChip(
                label: Text(g.displayName),
                selected: isSelected,
                selectedColor: AppTheme.gold,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.bg : Colors.white70,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: AppTheme.surface,
                side: BorderSide(
                  color: isSelected ? AppTheme.gold : Colors.white24,
                ),
                onSelected: (_) => setState(() => _selectedGender = g),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: AppTheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.gold, width: 2),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              TextButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: Text('Back',
                    style: AppTheme.body.copyWith(color: Colors.white54)),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _currentStep == 0
                  ? () => setState(() => _currentStep = 1)
                  : _createCharacter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: Text(
                _currentStep == 0 ? 'Next' : 'Start Game',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createCharacter() {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a first name'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
    context.go('/home');
  }
}

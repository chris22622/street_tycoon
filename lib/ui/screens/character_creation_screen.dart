import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/character_models.dart';
import '../../providers.dart';
import '../widgets/enhanced_character_avatar.dart';
import 'dart:math';

class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  ConsumerState<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends ConsumerState<CharacterCreationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _backstoryController = TextEditingController();
  final PageController _pageController = PageController();
  
  int _currentPage = 0;
  
  // Character attributes
  Gender _selectedGender = Gender.male;
  Ethnicity _selectedEthnicity = Ethnicity.caucasian;
  SkinTone _selectedSkinTone = SkinTone.medium;
  HairColor _selectedHairColor = HairColor.brown;
  HairStyle _selectedHairStyle = HairStyle.short;
  FaceShape _selectedFaceShape = FaceShape.oval;
  EyeColor _selectedEyeColor = EyeColor.brown;

  @override
  void initState() {
    super.initState();
    _randomizeCharacter();
  }

  void _randomizeCharacter() {
    final random = Random();
    setState(() {
      _selectedGender = Gender.values[random.nextInt(Gender.values.length)];
      _selectedEthnicity = Ethnicity.values[random.nextInt(Ethnicity.values.length)];
      _selectedSkinTone = SkinTone.values[random.nextInt(SkinTone.values.length)];
      _selectedHairColor = HairColor.values[random.nextInt(HairColor.values.length)];
      _selectedHairStyle = HairStyle.values[random.nextInt(HairStyle.values.length)];
      _selectedFaceShape = FaceShape.values[random.nextInt(FaceShape.values.length)];
      _selectedEyeColor = EyeColor.values[random.nextInt(EyeColor.values.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Create Character',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _randomizeCharacter,
            icon: const Icon(Icons.shuffle, color: Colors.white),
            tooltip: 'Randomize',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildBasicInfoPage(),
          _buildAppearancePage(),
          _buildBackstoryPage(),
          _buildFinalPage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF2A2A2A),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Back', style: TextStyle(color: Colors.white)),
              )
            else
              const SizedBox.shrink(),
            Row(
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
            if (_currentPage < 3)
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              )
            else
              ElevatedButton(
                onPressed: _createCharacter,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Create', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: EnhancedCharacterAvatar(
                    gender: _selectedGender,
                    ethnicity: _selectedEthnicity,
                    skinTone: _selectedSkinTone,
                    hairColor: _selectedHairColor,
                    hairStyle: _selectedHairStyle,
                    faceShape: _selectedFaceShape,
                    eyeColor: _selectedEyeColor,
                    size: 120,
                    showDetails: true,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: Gender.values.map((gender) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedGender = gender),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedGender == gender
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedGender == gender
                                        ? Colors.blue
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  gender.displayName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedGender == gender
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearancePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Customize Appearance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: EnhancedCharacterAvatar(
                            gender: _selectedGender,
                            ethnicity: _selectedEthnicity,
                            skinTone: _selectedSkinTone,
                            hairColor: _selectedHairColor,
                            hairStyle: _selectedHairStyle,
                            faceShape: _selectedFaceShape,
                            eyeColor: _selectedEyeColor,
                            size: 140,
                            showDetails: true,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildAppearanceOption('Ethnicity', Ethnicity.values, _selectedEthnicity, (value) {
                          setState(() => _selectedEthnicity = value);
                        }),
                        const SizedBox(height: 20),
                        _buildAppearanceOption('Skin Tone', SkinTone.values, _selectedSkinTone, (value) {
                          setState(() => _selectedSkinTone = value);
                        }),
                        const SizedBox(height: 20),
                        _buildAppearanceOption('Hair Color', HairColor.values, _selectedHairColor, (value) {
                          setState(() => _selectedHairColor = value);
                        }),
                        const SizedBox(height: 20),
                        _buildAppearanceOption('Hair Style', HairStyle.values, _selectedHairStyle, (value) {
                          setState(() => _selectedHairStyle = value);
                        }),
                        const SizedBox(height: 20),
                        _buildAppearanceOption('Face Shape', FaceShape.values, _selectedFaceShape, (value) {
                          setState(() => _selectedFaceShape = value);
                        }),
                        const SizedBox(height: 20),
                        _buildAppearanceOption('Eye Color', EyeColor.values, _selectedEyeColor, (value) {
                          setState(() => _selectedEyeColor = value);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceOption<T>(String title, List<T> options, T selectedValue, Function(T) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedValue == option;
              return GestureDetector(
                onTap: () => onChanged(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    option.toString().split('.').last.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackstoryPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Character Background',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Tell us about your character\'s background (optional)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _backstoryController,
                      decoration: InputDecoration(
                        hintText: 'Enter your character\'s backstory...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Character Summary',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: EnhancedCharacterAvatar(
                gender: _selectedGender,
                ethnicity: _selectedEthnicity,
                skinTone: _selectedSkinTone,
                hairColor: _selectedHairColor,
                hairStyle: _selectedHairStyle,
                faceShape: _selectedFaceShape,
                eyeColor: _selectedEyeColor,
                size: 200,
                showDetails: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_firstNameController.text.isNotEmpty ? _firstNameController.text : 'Unknown'} ${_lastNameController.text.isNotEmpty ? _lastNameController.text : 'Person'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gender: ${_selectedGender.displayName}',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  'Ethnicity: ${_selectedEthnicity.toString().split('.').last}',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                if (_backstoryController.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Background:',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _backstoryController.text,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _createCharacter() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both first and last name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create initial game state with character info
    final gameController = ref.read(gameControllerProvider.notifier);
    
    // Initialize character data in the existing GameState
    gameController.updateCharacterInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      gender: _selectedGender.name,
      ethnicity: _selectedEthnicity.name,
      skinTone: _selectedSkinTone.name,
      hairColor: _selectedHairColor.name,
      hairStyle: _selectedHairStyle.name,
      faceShape: _selectedFaceShape.name,
      eyeColor: _selectedEyeColor.name,
      backstory: _backstoryController.text.isNotEmpty ? _backstoryController.text : null,
    );

    if (mounted) {
      context.go('/main');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _backstoryController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

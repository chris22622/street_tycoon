// Simple test to verify audio service works
import 'lib/services/audio_service.dart';

void main() async {
  print('Testing AudioService...');
  
  // Initialize audio service
  await AudioService().initialize();
  
  // Test different sound effects
  print('Testing buy sound...');
  await AudioService().playSoundEffect(SoundEffect.buy);
  
  await Future.delayed(Duration(milliseconds: 500));
  
  print('Testing sell sound...');
  await AudioService().playSoundEffect(SoundEffect.sell);
  
  await Future.delayed(Duration(milliseconds: 500));
  
  print('Testing achievement sound...');
  await AudioService().playSoundEffect(SoundEffect.achievement);
  
  print('Audio test completed!');
}

import 'package:flutter/material.dart';

class EnergyPill extends StatelessWidget {
  final int currentEnergy;
  final int maxEnergy;

  const EnergyPill({
    super.key,
    required this.currentEnergy,
    this.maxEnergy = 100,
  });

  Color get energyColor {
    final percentage = currentEnergy / maxEnergy;
    if (percentage > 0.6) return Colors.green;
    if (percentage > 0.3) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (currentEnergy / maxEnergy).clamp(0.0, 1.0);
    
    return Tooltip(
      message: 'Energy: $currentEnergy/$maxEnergy\nAuto-ends the day when empty.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: energyColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: energyColor, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt,
              color: energyColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 60,
              height: 8,
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(energyColor),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$currentEnergy',
              style: TextStyle(
                color: energyColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

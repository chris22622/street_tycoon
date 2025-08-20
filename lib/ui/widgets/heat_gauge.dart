import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../logic/heat_service.dart';

class HeatGauge extends StatelessWidget {
  final int heat;

  const HeatGauge({
    super.key,
    required this.heat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = HeatService.getHeatProgress(heat);
    final label = HeatService.getHeatLabel(heat);
    
    Color gaugeColor;
    if (heat <= 20) {
      gaugeColor = Colors.green;
    } else if (heat <= 50) {
      gaugeColor = Colors.orange;
    } else if (heat <= 75) {
      gaugeColor = Colors.red;
    } else {
      gaugeColor = Colors.purple;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                    ),
                  ),
                  Text(
                    heat.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: gaugeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: gaugeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

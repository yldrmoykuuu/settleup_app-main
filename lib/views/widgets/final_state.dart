import 'package:flutter/material.dart';
import 'package:settleup_app/core/theme/app_colors.dart';

class FinalStateCard extends StatelessWidget {
  final String title;
  final double number;

  const FinalStateCard({super.key, required this.title, required this.number});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getStatusBg(isDark, number);
    final fgColor = AppColors.getStatusText(isDark, number);
    final isPositive = number >= 0;

    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor(isDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: fgColor,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "${number.toStringAsFixed(0)}₺",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

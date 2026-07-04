import 'package:flutter/material.dart';
import 'package:settleup_app/core/theme/app_colors.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double balance;
  final String status;
  final IconData? iconData;

  const GroupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.balance,
    required this.status,
    this.iconData,
  });

  static const List<Color> _palette = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
    Color(0xFF14B8A6),
  ];

  Color get _avatarColor => _palette[title.hashCode.abs() % _palette.length];

  String getStatusText() {
    if (balance > 0) {
      return "Sana borçlular";
    } else if (balance < 0) {
      return "Borcun var";
    } else {
      return "Hesap dengede";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarColor = _avatarColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColorFor(isDark)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [avatarColor, avatarColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.group, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isPositive ? '+' : ''}${balance.toStringAsFixed(0)}₺",
                style: TextStyle(
                  color: AppColors.getStatusText(isDark, balance),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getStatusBg(isDark, balance),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getStatusText(),
                  style: TextStyle(
                    color: AppColors.getStatusText(isDark, balance),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (iconData != null) ...[
            const SizedBox(width: 16),
            Icon(iconData, color: Theme.of(context).colorScheme.onSurface),
          ],
        ],
      ),
    );
  }
}

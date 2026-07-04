import 'package:flutter/material.dart';
import 'package:settleup_app/core/theme/app_colors.dart';

class ParticipantsCard extends StatelessWidget {
  final List<String> members;
  final VoidCallback onAddUser;

  const ParticipantsCard({
    super.key,
    required this.members,
    required this.onAddUser,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColorFor(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("KATILIMCILAR", style: Theme.of(context).textTheme.bodySmall),
              IconButton(
                onPressed: onAddUser,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.add, size: 16, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              ...members.take(3).map((e) => buildAvatar(e)).toList(),

              if (members.length > 3)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "+${members.length - 3}",
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.primaries[name.hashCode % Colors.primaries.length],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

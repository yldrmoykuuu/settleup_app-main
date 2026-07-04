import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/theme/app_colors.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/data/models/group_model.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/views/screens/AddExpenseScreen.dart';
import 'package:settleup_app/views/widgets/ScreenAppBar.dart';
import 'package:settleup_app/views/widgets/filter_chip.dart';
import 'package:settleup_app/views/widgets/gradient_button.dart';
import 'package:settleup_app/views/widgets/lucky_wheel.dart';

class LuckyWheelScreen extends StatefulWidget {
  const LuckyWheelScreen({super.key});

  @override
  State<LuckyWheelScreen> createState() => _LuckyWheelScreenState();
}

class _LuckyWheelScreenState extends State<LuckyWheelScreen> {
  final _wheelKey = GlobalKey<LuckyWheelState>();
  GroupModel? _selectedGroup;
  bool _initialized = false;

  void _selectGroup(GroupModel group) {
    setState(() => _selectedGroup = group);
    context.read<AuthViewModel>().loadUsernames(group.members);
  }

  void _handleSpinComplete(int winnerIndex) {
    final group = _selectedGroup;
    if (group == null) return;

    final authVM = context.read<AuthViewModel>();
    final currentUid = authVM.currentUser?.uid;
    final winnerUid = group.members[winnerIndex];
    final winnerName = winnerUid == currentUid
        ? "Sen"
        : (authVM.userNames[winnerUid] ?? "?");

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Kazanan Belirlendi"),
        content: Text(
          "Şanslı Kişi: $winnerName!\nHesabı $winnerName ödüyor, herkes için adil bir seçim yapıldı.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Tamam"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.zero),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(
                    group: group,
                    initialPayerUid: winnerUid,
                  ),
                ),
              );
            },
            child: const Text("Harcama Ekle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashVm = context.watch<DashboardViewmodel>();
    final authVm = context.watch<AuthViewModel>();

    if (!_initialized && dashVm.groups.isNotEmpty) {
      _initialized = true;
      _selectedGroup = dashVm.groups.first;
      Future.microtask(
        () => context.read<AuthViewModel>().loadUsernames(
          dashVm.groups.first.members,
        ),
      );
    }

    return Scaffold(
      appBar: ScreenAppBar(
        title: "Şanslı Çark",
        leftIcon: Icons.arrow_back,
        onLeftTap: () => Navigator.pop(context),
      ),
      body: dashVm.groups.isEmpty
          ? _buildEmptyState(context)
          : _buildContent(context, dashVm, authVm),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.casino_rounded,
              size: 56,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Çark için önce bir grup gerekiyor",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Şanslı çarkı çevirebilmek için önce bir grup oluştur",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardViewmodel dashVm,
    AuthViewModel authVm,
  ) {
    final group = _selectedGroup ?? dashVm.groups.first;
    final currentUid = authVm.currentUser?.uid;
    final labels = group.members
        .map((uid) => uid == currentUid ? "Sen" : (authVm.userNames[uid] ?? "..."))
        .toList();
    final isSpinning = _wheelKey.currentState?.isSpinning ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dashVm.groups.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final g = dashVm.groups[index];
                return FilterChipWidget(
                  filterName: g.name,
                  isSelected: g.id == group.id,
                  onTap: () => _selectGroup(g),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Center(
            child: Text(
              "Bugün hesabı kim ödüyor?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Center(
            child: labels.length < 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Text(
                      "Çarkı çevirebilmek için grupta en az 2 katılımcı olmalı",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : LuckyWheel(
                    key: _wheelKey,
                    labels: labels,
                    onSpinComplete: _handleSpinComplete,
                  ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (labels.length >= 2)
            GradientButton(
              text: isSpinning ? "Çark Dönüyor..." : "Çarkı Çevir",
              isLoading: false,
              onTap: () => setState(() => _wheelKey.currentState?.spin()),
            ),

          const SizedBox(height: AppSpacing.lg),

          Text("Katılımcılar", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...group.members.map((uid) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final name = uid == currentUid ? "Sen" : (authVm.userNames[uid] ?? "...");
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardColor(isDark),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColorFor(isDark)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : "?"),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(name),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

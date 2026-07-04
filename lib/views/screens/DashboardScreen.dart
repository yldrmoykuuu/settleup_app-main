import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/services/preferences_service.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/main.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/views/screens/GroupDetailScreen.dart';
import 'package:settleup_app/views/screens/GroupListScreen.dart';
import 'package:settleup_app/views/screens/LuckyWheelScreen.dart';
import 'package:settleup_app/views/widgets/ScreenAppBar.dart';
import 'package:settleup_app/views/widgets/final_state.dart';
import 'package:settleup_app/views/widgets/group_card.dart';
import 'package:settleup_app/views/widgets/info_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewmodel>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: ScreenAppBar(
        title: "OrtakHesap",
        leftIcon: Icons.menu,
        rightIcon: Icons.notifications_outlined,
        onLeftTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.savings_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    "OrtakHesap",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text("Koyu Mod"),
              trailing: Switch(
                value: themeNotifier.value,
                onChanged: (value) {
                  themeNotifier.value = value;
                  PreferencesService().saveIsDarkMode(value);
                },
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Çıkış Yap"),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthViewModel>().logout();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardViewmodel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          title: "Net Durum",
          value:
              "${vm.netBalance >= 0 ? '+' : ''}${vm.netBalance.toStringAsFixed(0)}₺",
          icon: Icons.account_balance_wallet_rounded,
          accentColor: const Color(0xFF6366F1),
        ),
        const SizedBox(height: AppSpacing.sm),

        Row(
          children: [
            Expanded(
              child: FinalStateCard(
                title: "Toplam Alacak",
                number: vm.totalCredit,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FinalStateCard(
                title: "Toplam Borç",
                number: vm.totalDebt,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),
        _buildLuckyWheelShortcut(context),

        const SizedBox(height: AppSpacing.lg),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Grup Listesi", style: Theme.of(context).textTheme.titleLarge),
            if (vm.groups.isNotEmpty)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GroupListScreem()),
                  );
                },
                child: Text(
                  "Tümünü Gör",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        if (vm.groups.isEmpty)
          Expanded(child: _buildEmptyState(context))
        else
          Expanded(
            child: ListView.builder(
              itemCount: vm.groups.length > 3 ? 3 : vm.groups.length,
              itemBuilder: (context, index) {
                final group = vm.groups[index];
                final balance = group.balances[vm.userId] ?? 0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(group: group),
                      ),
                    );
                  },
                  child: GroupCard(
                    title: group.name,
                    subtitle: "${group.members.length} Katılımcı",
                    balance: balance,
                    status: "",
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLuckyWheelShortcut(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LuckyWheelScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.casino_rounded, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Şanslı Çark",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Bugün hesabı kim ödeyecek?",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.15),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Henüz bir grup yok",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Arkadaşlarınla harcama paylaşmaya başlamak için bir grup oluştur",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GroupListScreem()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Grup Oluştur"),
          ),
        ],
      ),
    );
  }
}

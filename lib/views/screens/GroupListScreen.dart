import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/components/InputTextField.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/views/screens/GroupDetailScreen.dart';
import 'package:settleup_app/views/widgets/ScreenAppBar.dart';
import 'package:settleup_app/views/widgets/filter_chip.dart';
import 'package:settleup_app/views/widgets/group_card.dart';

class GroupListScreem extends StatefulWidget {
  const GroupListScreem({super.key});
  @override
  State<GroupListScreem> createState() => _GroupListScreemState();
}

class _GroupListScreemState extends State<GroupListScreem> {
  bool isSearching = false;
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: "Gruplar",
        leftIcon: Icons.arrow_back,
        onLeftTap: () => Navigator.pop(context),
        rightIcon: isSearching ? Icons.close : Icons.search,
        isSearching: isSearching,

        onRightTap: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
        onSearchChanged: (value) {
          setState(() {
            searchText = value.toLowerCase();
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGroupDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FilterChipWidget(
                    filterName: "Tümü",
                    isSelected: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilterChipWidget(
                    filterName: "Alacaklı",
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilterChipWidget(
                    filterName: "Borçlu",
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: Consumer<DashboardViewmodel>(
                builder: (context, vm, _) {
                  final filteredGroups = vm.groups.where((groups) {
                    return groups.name.toLowerCase().contains(searchText);
                  }).toList();

                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.groups.isEmpty) {
                    return _buildEmptyState(
                      context,
                      icon: Icons.groups_outlined,
                      title: "Henüz grup yok",
                      subtitle: "Sağ alttaki + butonuna dokunarak ilk grubunu oluştur",
                    );
                  }

                  if (filteredGroups.isEmpty) {
                    return _buildEmptyState(
                      context,
                      icon: Icons.search_off_rounded,
                      title: "Sonuç bulunamadı",
                      subtitle: "\"$searchText\" ile eşleşen bir grup yok",
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = filteredGroups[index];

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
                          balance: (group.balances[vm.userId] ?? 0).toDouble(),
                          status: "",
                          iconData: Icons.chevron_right,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddGroupDialog(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text("Yeni Grup"),
        content: InputTextField(
          hintText: "Grup adı gir",
          controller: controller,
          icon: Icons.group_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.zero),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<DashboardViewmodel>().addGroup(controller.text);

                Navigator.pop(context);
              }
            },
            child: const Text("Ekle"),
          ),
        ],
      );
    },
  );
}

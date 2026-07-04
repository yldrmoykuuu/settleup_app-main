import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/components/InputTextField.dart';
import 'package:settleup_app/core/theme/app_colors.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'package:settleup_app/data/models/expense_model.dart';
import 'package:settleup_app/data/models/group_model.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/views/screens/AddExpenseScreen.dart';
import 'package:settleup_app/views/widgets/ScreenAppBar.dart';
import 'package:settleup_app/views/widgets/info_card.dart';
import 'package:settleup_app/views/widgets/participants_card%20.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  void initState() {
    super.initState();

    final vm = context.read<AuthViewModel>();
    vm.loadUsernames(widget.group.members);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final dashVm = context.watch<DashboardViewmodel>();
    final totalExpense = _calculateTotal(widget.group);
    final myBalance = widget.group.balances[dashVm.userId] ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(
        title: widget.group.name,
        leftIcon: Icons.arrow_back,
        onLeftTap: () => Navigator.pop(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(group: widget.group),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Harcama Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              widget.group.name.toUpperCase(),
              style: AppTextStyles.title.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBalancePill(context, myBalance, isDark),
            const SizedBox(height: AppSpacing.md),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: "TOPLAM HARCAMA",
                      value: "${totalExpense.toStringAsFixed(0)}₺",
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ParticipantsCard(
                      members: widget.group.members
                          .map((uid) => vm.userNames[uid] ?? "?")
                          .toList(),
                      onAddUser: () => _showAddUserDialog(context),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Expanded(
              child: StreamBuilder<List<ExpenseModel>>(
                stream: context.read<DashboardViewmodel>().getExpenses(
                  widget.group.id,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final expenses = snapshot.data!;
                  final authVM = context.watch<AuthViewModel>();
                  final debts = calculateDebts(widget.group, authVM.userNames);

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Harcama Listesi",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.sm),
                      ),
                      if (expenses.isEmpty)
                        SliverToBoxAdapter(
                          child: _buildEmptyExpenses(context),
                        )
                      else
                        SliverList.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            final paidByName =
                                authVM.userNames[expense.paidBy] ?? "?";

                            return _buildExpenseRow(
                              context,
                              expense,
                              paidByName,
                              isDark,
                            );
                          },
                        ),

                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.lg),

                            Text(
                              "Ödeme Dengesi",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            if (debts.isEmpty)
                              const Text("Herkes dengede 🎉")
                            else
                              ...debts.map(
                                (e) => Container(
                                  margin: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardColor(isDark),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.borderColorFor(isDark),
                                    ),
                                  ),
                                  child: Text(e),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalancePill(BuildContext context, double balance, bool isDark) {
    final text = balance > 0
        ? "${balance.toStringAsFixed(0)}₺ alacaklısın"
        : balance < 0
        ? "${balance.abs().toStringAsFixed(0)}₺ borcun var"
        : "Hesap dengede";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.getStatusBg(isDark, balance),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            balance >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
            color: AppColors.getStatusText(isDark, balance),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppColors.getStatusText(isDark, balance),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(
    BuildContext context,
    ExpenseModel expense,
    String paidByName,
    bool isDark,
  ) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "$paidByName ödedi • ${_formatDate(expense.date)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Text(
            "${expense.amount.toStringAsFixed(0)}₺",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyExpenses(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Henüz harcama eklenmedi",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Sağ alttaki butona dokunarak ilk harcamayı ekle",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  double _calculateTotal(GroupModel group) {
    double total = 0;
    group.balances.forEach((key, value) {
      total += value;
    });
    return total.abs();
  }

  void _showAddUserDialog(BuildContext context) {
    final controller = TextEditingController();
    final vm = context.read<AuthViewModel>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Kullanıcı Ekle"),
        content: InputTextField(
          hintText: "Kullanıcı adı gir",
          controller: controller,
          icon: Icons.person_add_alt_1_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.zero),
            onPressed: () async {
              final error = await vm.addUserByUsername(
                widget.group.id,
                controller.text.trim(),
              );

              if (!context.mounted) return;
              Navigator.pop(context);

              if (error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              }
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final now = DateTime.now();

  if (date.day == now.day) return "Bugün";
  if (date.day == now.day - 1) return "Dün";

  return "${date.day}.${date.month}.${date.year}";
}

List<String> calculateDebts(GroupModel group, Map<String, String> userNames) {
  final creditors = <MapEntry<String, double>>[];
  final debtors = <MapEntry<String, double>>[];

  group.balances.forEach((uid, balance) {
    if (balance > 0) {
      creditors.add(MapEntry(uid, balance));
    } else if (balance < 0) {
      debtors.add(MapEntry(uid, balance.abs()));
    }
  });

  List<String> results = [];

  int i = 0;
  int j = 0;

  while (i < debtors.length && j < creditors.length) {
    final debtor = debtors[i];
    final creditor = creditors[j];

    final amount = debtor.value < creditor.value
        ? debtor.value
        : creditor.value;

    final debtorName = userNames[debtor.key] ?? "?";
    final creditorName = userNames[creditor.key] ?? "?";

    results.add("$debtorName → $creditorName ${amount.toStringAsFixed(0)}₺");

    debtors[i] = MapEntry(debtor.key, debtor.value - amount);
    creditors[j] = MapEntry(creditor.key, creditor.value - amount);

    if (debtors[i].value == 0) i++;
    if (creditors[j].value == 0) j++;
  }

  return results;
}

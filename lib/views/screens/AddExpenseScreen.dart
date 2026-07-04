import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/theme/app_colors.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'package:settleup_app/data/models/group_model.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/views/widgets/ScreenAppBar.dart';
import 'package:settleup_app/views/widgets/gradient_button.dart';

class AddExpenseScreen extends StatefulWidget {
  final GroupModel group;
  final String? initialPayerUid;
  const AddExpenseScreen({
    super.key,
    required this.group,
    this.initialPayerUid,
  });
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? selectedPayer;
  List<String> selectedParticipants = [];

  final amountController = TextEditingController();
  final titleController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    final members = widget.group.members;

    selectedPayer = widget.initialPayerUid ?? members.first;
    selectedParticipants = List.from(members);
    Future.microtask(() {
      context.read<AuthViewModel>().loadUsernames(members);
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.replaceAll(',', '.'));

    if (title.isEmpty) {
      setState(() => _errorText = "Lütfen bir açıklama gir");
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _errorText = "Lütfen geçerli bir tutar gir");
      return;
    }
    if (selectedPayer == null) {
      setState(() => _errorText = "Ödeyen kişiyi seç");
      return;
    }

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    try {
      await context.read<DashboardViewmodel>().addExpense(
        group: widget.group,
        title: title,
        amount: amount,
        paidBy: selectedPayer!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harcama eklendi")));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorText = "Harcama eklenirken bir hata oluştu";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: "Harcama Ekle",
        leftIcon: Icons.close,
        onLeftTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountInput(context),
            const SizedBox(height: AppSpacing.lg),
            _buildExplainInput(context),
            const SizedBox(height: AppSpacing.lg),
            Text("Kim Ödedi?", style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),
            _buildPayerSection(),

            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kimler Katıldı?", style: AppTextStyles.title),

                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedParticipants = List.from(widget.group.members);
                    });
                  },
                  child: const Text("Tümünü Seç"),
                ),
              ],
            ),

            _buildUserList(),

            if (_errorText != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                _errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              text: "Harcama Ekle",
              onTap: _submit,
              isLoading: _isSubmitting,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildPayerSection() {
    final members = widget.group.members;
    final authVM = context.watch<AuthViewModel>();
    final currentUid = context.read<AuthViewModel>().currentUser!.uid;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: members.map((uid) {
          final isSelected = selectedPayer == uid;
          final name = authVM.userNames[uid] ?? "...";
          final displayName = uid == currentUid ? "Sen" : name;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPayer = uid;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.15),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : "?",
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserList() {
    final members = widget.group.members;
    final authVM = context.watch<AuthViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: members.map((uid) {
        final name = authVM.userNames[uid] ?? "...";
        final isSelected = selectedParticipants.contains(uid);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedParticipants.remove(uid);
              } else {
                selectedParticipants.add(uid);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                  : AppColors.cardColor(isDark),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : AppColors.borderColorFor(isDark),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : "?"),
                ),

                const SizedBox(width: 12),

                Expanded(child: Text(name)),

                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExplainInput(BuildContext context) {
    return TextField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: "Açıklama (Örn: Akşam Yemeği)",
        prefixIcon: Icon(
          Icons.shopping_bag_outlined,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tutar", style: AppTextStyles.title),

        const SizedBox(height: AppSpacing.sm),

        Row(
          children: [
            Text(
              "₺",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: "0.00",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),

            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    final value = double.tryParse(amountController.text) ?? 0;
                    amountController.text = (value + 10).toStringAsFixed(0);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    final value = double.tryParse(amountController.text) ?? 0;
                    amountController.text = (value - 10 < 0 ? 0 : value - 10)
                        .toStringAsFixed(0);
                  },
                ),
              ],
            ),
          ],
        ),
        Container(height: 1, color: AppColors.primary),
      ],
    );
  }
}

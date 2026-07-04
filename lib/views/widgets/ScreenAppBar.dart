import 'package:flutter/material.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final bool isSearching;
  final ValueChanged<String>? onSearchChanged;
  const ScreenAppBar({
    super.key,
    required this.title,
    this.leftIcon,
    this.rightIcon,
    this.onLeftTap,
    this.onRightTap,
    this.isSearching = false,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? TextField(
              autofocus: true,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: "Ara ...",
                border: InputBorder.none,
                filled: false,
              ),
              onChanged: onSearchChanged,
            )
          : Text(title),

      leading: leftIcon != null
          ? IconButton(icon: Icon(leftIcon), onPressed: onLeftTap)
          : null,

      actions: rightIcon != null
          ? [IconButton(icon: Icon(rightIcon), onPressed: onRightTap)]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

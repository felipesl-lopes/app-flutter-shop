import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool? centerTitle;

  const DrawerAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: AppColors.primary,
      iconTheme: IconThemeData(color: AppColors.white),
      title: titleWidget ??
          Text(
            title ?? '',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

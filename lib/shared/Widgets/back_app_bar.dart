// ignore_for_file: must_be_immutable

import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? actions;

  BackAppBar({required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: AppColors.white),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: IconThemeData(color: AppColors.white),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

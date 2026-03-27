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
      backgroundColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white),
      title: titleWidget ??
          Text(
            title ?? '',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

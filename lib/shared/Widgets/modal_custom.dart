import 'package:flutter/material.dart';

Future<dynamic> modalCustom({
  required BuildContext context,
  required String title,
  required String text,
  required VoidCallback onTap,
  IconData? icon,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Icon(icon,
                  size: 40, color: colorScheme.onSurface.withOpacity(0.5)),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text("CANCELAR",
                      style: TextStyle(color: colorScheme.onSurface)),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: onTap,
                  child: Text(
                    "CONFIRMAR",
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

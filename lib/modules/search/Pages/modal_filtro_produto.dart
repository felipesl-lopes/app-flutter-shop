import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> modalFiltroProduto({required BuildContext context}) async {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Filtrar busca',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Text('Preço'),
            Text('Categoria'),
            Text('Promocional'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Cancelar')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Filtrar',
                      style: TextStyle(color: AppColors.white),
                    )),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

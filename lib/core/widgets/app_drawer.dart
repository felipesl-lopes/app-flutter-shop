import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/session_service.dart';
import 'package:appshop/core/widgets/modal_custom.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(color: colorScheme.onPrimary),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bem vindo(a) ${user?.name}",
                    style:
                        TextStyle(color: colorScheme.onPrimary, fontSize: 20)),
              ],
            ),
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Início"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.HOME,
            ),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.person),
              title: Text("Meu perfil"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.PROFILE,
                );
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Meu carrinho"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.CART,
                );
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text("Minhas compras"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.COMPRAS,
                );
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.inventory),
              title: Text("Gerenciar produtos"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.MANAGE_PRODUCTS,
                );
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.primary),
            title: Text("Sair", style: TextStyle(color: colorScheme.primary)),
            onTap: () {
              modalCustom(
                context: context,
                onTap: () async => await SessionService().logout(context),
                icon: Icons.logout,
                title: "Deseja sair?",
                text:
                    "Após confirmar sua saída precisará se logar novamente na próxima vez.",
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

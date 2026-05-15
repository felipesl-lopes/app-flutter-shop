import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/shared/Widgets/modal_custom.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(color: AppColors.white),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bem vindo(a) ${user?.name}",
                    style: TextStyle(color: AppColors.white, fontSize: 20)),
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
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.PROFILE,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Meu carrinho"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.CART,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Minhas compras"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.COMPRAS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text("Gerenciar produtos"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.MANAGE_PRODUCTS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.primary),
            title: Text("Sair", style: TextStyle(color: AppColors.primary)),
            onTap: () {
              modalCustom(
                context: context,
                onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).deslogar();
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.AUTH_OR_HOME,
                  );
                },
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

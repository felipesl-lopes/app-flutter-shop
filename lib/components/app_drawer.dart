import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = auth.user;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.purple,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Bem vindo ${user?.name}",
                style: TextStyle(color: Colors.white)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Início"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.HOME,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Meus pedidos"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.ORDERS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_note),
            title: Text("Gerenciar produtos"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.PRODUCTS,
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
              leading: Icon(Icons.logout, color: Colors.purple),
              title: Text("Sair", style: TextStyle(color: Colors.purple)),
              onTap: () => {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text("Deseja sair?"),
                              content: Text("Confirmar logout."),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<Auth>(context, listen: false)
                                          .logout();
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        AppRoutes.AUTH_OR_HOME,
                                      );
                                    },
                                    child: Text("Confirmar"))
                              ],
                            ))
                  }),
        ],
      ),
    );
  }
}

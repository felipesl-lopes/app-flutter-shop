import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
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
            backgroundColor: Colors.purple,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Bem vindo(a) ${user?.name}",
                style: TextStyle(color: Colors.white)),
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
            leading: Icon(Icons.payment),
            title: Text("Minhas compras"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.ORDERS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_note),
            title: Text("Gerenciar produtos"),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.MANAGE_PRODUCTS,
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
            onTap: () {
              showDialog(
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
                          "Deseja sair?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Icon(Icons.logout,
                              size: 40, color: Colors.grey),
                        ),
                        Text(
                          "Após confirmar sua saída, precisará se logar novamente na próxima vez.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text("CANCELAR", style: TextStyle(color: Colors.purple)),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .logout();
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.AUTH_OR_HOME,
                                );
                              },
                              child: Text(
                                "CONFIRMAR",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

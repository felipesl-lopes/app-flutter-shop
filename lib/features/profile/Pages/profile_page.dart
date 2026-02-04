import 'package:appshop/core/utils/get_iniciais.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.purple;
    final _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Perfil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        backgroundColor: themeColor,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            _ProfileHeader(themeColor: themeColor, auth: _auth),
            SizedBox(height: 24),
            _SectionTitle(title: "Configurações"),
            SizedBox(height: 12),
            _TopicsSection(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color themeColor;
  final AuthProvider auth;

  const _ProfileHeader({required this.themeColor, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withOpacity(0.08),
              themeColor.withOpacity(0.03),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 120,
              width: 120,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeColor.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: themeColor.withOpacity(0.2),
                child: auth.isAuth
                    ? Icon(Icons.person, size: 64, color: Colors.black54)
                    : Text(
                        getIniciais(auth.isAuth ? auth.user!.name : ''),
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              auth.user!.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              auth.isAuth ? auth.email.toString() : "",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _TopicsSection extends StatelessWidget {
  const _TopicsSection();

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.purple;
    final topics = [
      (Icons.person_outline, "Dados do usuário"),
      (Icons.security_outlined, "Segurança e conta"),
      (Icons.link, "Integração com o app"),
      (Icons.tune_rounded, "Preferências"),
      (Icons.info_outline_rounded, "Sobre"),
      (Icons.more_horiz_rounded, "Outros"),
    ];

    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            ...topics.asMap().entries.map((entry) {
              final index = entry.key;
              final (icon, title) = entry.value;
              return Column(
                children: [
                  Topico(
                    title: title,
                    icon: Icon(icon, color: themeColor, size: 22),
                    paginaDestino: title,
                  ),
                  if (index < topics.length - 1) Divider(height: 1, indent: 56),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class Topico extends StatelessWidget {
  final String title;
  final Icon icon;
  final String paginaDestino;

  const Topico({
    required this.title,
    required this.icon,
    required this.paginaDestino,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: () {},
    );
  }
}

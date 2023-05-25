import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:att_2_flutter/MyApp.dart';
import 'package:att_2_flutter/Moveis.dart';
import 'package:att_2_flutter/GastosFixos.dart';
import 'package:att_2_flutter/GastosVariaveis.dart';
import 'package:att_2_flutter/Usuario.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Luiza ou Rhuan"),
            accountEmail: Text("email@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/user_photo.jpg"),
            ),
            decoration: BoxDecoration(color: Color(0xff764abc)),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                NavItem(
                  text: 'Home',
                  icon: Icons.home,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                NavItem(
                  text: 'Móveis',
                  icon: Icons.chair,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/moveis');
                  },
                ),
                NavItem(
                  text: 'Gastos Fixos',
                  icon: Icons.money_off,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/gastosFixos');
                  },
                ),
                NavItem(
                  text: 'Gastos Variáveis',
                  icon: Icons.attach_money,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/gastosVariaveis');
                  },
                ),
                NavItem(
                  text: 'Sair',
                  icon: Icons.logout,
                  onTap: () {
                    // Implemente a lógica de logout aqui
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const NavItem({
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

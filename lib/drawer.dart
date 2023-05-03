import 'package:att_2_flutter/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:att_2_flutter/Usuario.dart';
import 'Moveis.dart';
import 'GastosFixos.dart';
import 'GastosVariaveis.dart';

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
              children: const [
                NavItem(
                  text: 'Home',
                  icon: Icons.home,
                  screen: MyApp(),
                ),
                NavItem(
                  text: 'Móveis',
                  icon: Icons.chair,
                  screen: Moveis(),
                ),
                NavItem(
                  text: 'Gastos Fixos',
                  icon: Icons.money_off,
                  screen: GastosFixos(),
                ),
                NavItem(
                  text: 'Gastos Variáveis',
                  icon: Icons.attach_money,
                  screen: GastosVariaveis(),
                ),
                NavItem(
                  text: 'Sair',
                  icon: Icons.logout,
                  //Momentaneo
                  screen: Usuario(),
                  // Lemnbrar de colocar a lógica do Disconect aqui depois:
                  // onTap: () {
                  //     Navigator.of(context).pushNamed('/login');
                  //  },
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
  final Widget? screen;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.text,
    this.icon,
    this.screen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap ??
          () {
            Navigator.of(context).pop();
            Navigator.of(context).push(_Page(screen!));
          },
    );
  }
}

class _Page extends MaterialPageRoute<void> {
  _Page(Widget screen)
      : super(builder: (BuildContext context) {
          return screen;
        });
}

import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Apartamentos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Resumo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chair),
          label: 'Móveis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Gastos Fixos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_off),
          label: 'Gastos Variáveis',
        ),
      ],
    );
  }
}

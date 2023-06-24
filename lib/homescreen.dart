import 'package:flutter/material.dart';
import 'GastosFixos.dart';
import 'GastosVariaveis.dart';
import 'Moveis.dart';
import 'selectapartment.dart';
import 'bottomnavigationbar.dart';
import 'appscaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    SelectApartmentScreen(),
    HomeScreen(),
    Moveis(),
    GastosFixos(),
    GastosVariaveis(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: _currentIndex,
      screens: _screens,
      onScreenChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

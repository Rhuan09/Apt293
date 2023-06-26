import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  const CustomScaffold({
    Key? key,
    required this.screens,
    required this.bottomNavigationBarItems,
  }) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: widget.screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.textColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textColorsumindo,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: widget.bottomNavigationBarItems,
      ),
    );
  }
}

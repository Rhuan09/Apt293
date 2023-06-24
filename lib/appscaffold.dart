import 'package:flutter/material.dart';
import 'bottomnavigationbar.dart';

class AppScaffold extends StatefulWidget {
  final int currentIndex;
  final List<Widget> screens;
  final ValueChanged<int> onScreenChanged;

  const AppScaffold({
    Key? key,
    required this.currentIndex,
    required this.screens,
    required this.onScreenChanged,
  }) : super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page!.round() != widget.currentIndex) {
        widget.onScreenChanged(_pageController.page!.round());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: widget.screens,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../views/home_page.dart';
import '../views/person_page.dart';

class MenuViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<MenuItem> _menuItems = [
    MenuItem(title: 'Home', icon: Icons.home),
    MenuItem(title: 'Person', icon: Icons.person_search),
  ];

  int get selectedIndex => _selectedIndex;
  List<MenuItem> get menuItems => _menuItems;

  void selectMenuItem(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Widget get currentPage {
    switch (_selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      default:
        return HomePage();
    }
  }
}

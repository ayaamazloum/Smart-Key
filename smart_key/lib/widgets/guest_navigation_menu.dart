import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

class GuestNavigationMenu extends StatefulWidget {
  const GuestNavigationMenu({super.key});

  @override
  State<GuestNavigationMenu> createState() => GuestNavigationMenuState();
}

class GuestNavigationMenuState extends State<GuestNavigationMenu> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            elevation: 0,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

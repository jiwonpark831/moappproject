import "package:flutter/material.dart";

import "chat_screen.dart";
import "home.dart";
import "setting.dart";
import "friend.dart";

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    FriendPage(),
    ChatScreen(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
               type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'friend'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'message'),
           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
        ],
         //selectedIconTheme: IconThemeData(color: Colors.black),
        //  selectedLabelStyle: b13,
         // unselectedLabelStyle: IconThemeData(color: Colors.black),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

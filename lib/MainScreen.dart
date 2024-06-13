import "package:flutter/material.dart";
import "package:moappproject/chatroom.dart";
import "package:moappproject/setting.dart";

import "home.dart";
import "profile.dart";
import "friend.dart";
import "map.dart";

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
    GoogleMapPage(),
    //ChatScreen(),
    ChatroomPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: 30,
              ),
              label: 'friend'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                size: 30,
              ),
              label: 'map'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 30,
              ),
              label: 'message'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
              label: 'setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(color: Colors.black),
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:lab/alldevices.dart';
import 'package:lab/damaged.dart';
import 'package:lab/department.dart';
import 'package:lab/used.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AllDevicesScreen(),
    UsedPhonesScreen(),
    DamagedPhonesScreen(),
    PdfListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.all_inbox),
            title: Text('All Devices'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.device_hub_rounded),
            title: Text('Used'),
          ),
          FlashyTabBarItem(icon: Icon(Icons.build), title: Text('Damaged')),
          FlashyTabBarItem(icon: Icon(Icons.report), title: Text('Reports')),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Dashboard Screen"));
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Notifications Screen"));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile Screen"));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Settings Screen"));
  }
}

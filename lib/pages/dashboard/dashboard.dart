import 'package:flutter/material.dart';
import 'package:proyekakhir/pages/home/homePage.dart';
import 'package:proyekakhir/pages/profile/profilePage.dart';
import 'package:proyekakhir/config/app/appColor.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;

  final List<Widget> _child = [HomePage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: _child[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.white,
        unselectedItemColor: AppColor.dark.withOpacity(0.65),
        selectedItemColor: AppColor.primary,
        currentIndex: _index,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

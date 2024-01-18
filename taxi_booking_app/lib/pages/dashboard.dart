import 'package:flutter/material.dart';
import 'package:taxi_booking_app/pages/account_page.dart';
import 'package:taxi_booking_app/pages/home_page.dart';
import 'package:taxi_booking_app/pages/profile_page.dart';
import 'package:taxi_booking_app/pages/profile_setting.dart';
import 'package:taxi_booking_app/pages/search_destination.dart';
import 'package:taxi_booking_app/pages/trips_page.dart';
import 'package:taxi_booking_app/view/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int indexSelected = 0;

  onBarItemClicked(int i) {
    setState(() {
      indexSelected = i;
      controller!.index = indexSelected;
    });
  }

  @override
  void initState() {
    
    super.initState();

    controller = TabController(length: (4), vsync: this);
  }

  @override
  void dispose() {
    
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: const [
        HomePage(),
        SearchDestination(),
        HomeScreen(),
        AccountScreen(),
        
      ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"),
            BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: "Hire"),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"),
            BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings"),
        ],
        currentIndex: indexSelected,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.green,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onBarItemClicked,
        ),
        
        
    );
  }
}

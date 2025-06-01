

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthy_bite_project/views/screens/home_module/graph_screen.dart';
import 'package:healthy_bite_project/views/screens/home_module/home_screen.dart';
import 'package:healthy_bite_project/views/screens/home_module/profile_screen.dart';
import 'package:healthy_bite_project/views/screens/home_module/setting_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pages = [
    HomeScreen(),
    GraphScreen(),
    SettingScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body : pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ]
        ),
        child: BottomNavigationBar(
          backgroundColor:Color(0xffF7F4F0),
          elevation: 0,
          selectedItemColor: Color(0xff3A3734),
          unselectedItemColor: Colors.grey.shade600.withOpacity(0.6),
          currentIndex: currentIndex,
            onTap: (value){
            setState(() {
              currentIndex = value;
            });
            },
            items: [
          BottomNavigationBarItem(icon: Icon(Icons.house_sharp,size: 25.sp,),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph,size: 25,),label: 'Graph'),
          BottomNavigationBarItem(icon: Icon(Icons.settings,size: 25.sp),label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person,size: 25.sp),label: 'Profile'),
        ]),
      ),
    );
    
  }
}

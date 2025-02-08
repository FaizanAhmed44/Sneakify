import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/analytics/analytics_admin.dart';
import 'package:ecommerce_app/features/Admin/home/homescreen_admin.dart';
import 'package:ecommerce_app/features/Admin/orders/view/order_admin_screen.dart';
import 'package:ecommerce_app/features/Admin/profile/view/profile_screen_admin.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/screen/upload_data_screen.dart';

import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBarAdmin extends StatefulWidget {
  const CustomBottomNavBarAdmin({super.key});

  @override
  State<CustomBottomNavBarAdmin> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBarAdmin> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Add your action here for the middle button
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddProduct(),
              ),
            );
          },
          child: const Icon(
            FluentIcons.add_32_filled,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: theamNotifier.isDark ? mainDarkColor : Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 15.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FluentIcons.home_more_24_regular,
                  color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  // Add action here
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.analytics_outlined,
                  color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  // Add action here
                },
              ),
              const SizedBox(width: 40), // Space for the floating button
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: _currentIndex == 2 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  // Add action here
                },
              ),
              IconButton(
                icon: Icon(
                  FluentIcons.person_24_regular,
                  color: _currentIndex == 3 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  // Add action here
                },
              ),
            ],
          ),
        ),
        body: _getSelectedTab(_currentIndex),
      );
    });
  }

  Widget _getSelectedTab(int index) {
    switch (index) {
      case 0:
        return const HomescreenAdmin();
      case 1:
        return const AnalyticsPage();
      case 2:
        return const OrderAdminScreen();
      case 3:
        return const ProfileScreenAdmin();
      default:
        return const HomescreenAdmin();
    }
  }
}

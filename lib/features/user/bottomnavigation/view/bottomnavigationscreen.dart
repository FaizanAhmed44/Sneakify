import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/cart/view/cartscreen.dart';
import 'package:ecommerce_app/features/user/favorite/view/favoritescren.dart';
import 'package:ecommerce_app/features/user/home/view/homescreen.dart';
import 'package:ecommerce_app/features/user/notification/view/notification.dart';
import 'package:ecommerce_app/features/user/profile/view/profilescreen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
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
                builder: (context) => const CartScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.shopping_bag_outlined,
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
                  Icons.favorite_border,
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
                  Icons.notifications_outlined,
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
        return const Homescreen();
      case 1:
        return const Favoritescren();
      case 2:
        return const NotificationScreen();
      case 3:
        return const Profilescreen();
      default:
        return const Homescreen();
    }
  }
}

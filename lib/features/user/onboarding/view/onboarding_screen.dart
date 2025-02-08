import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/login/view/loginscreen.dart';
import 'package:ecommerce_app/features/user/onboarding/view/introscreen.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activePage = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'color': '#ffe24e',
      'title': 'Start Journey With Nike',
      'image': 'asset/images/shoes1.png',
      'description': "Smart, Gorgeous & Fashionable Collection",
      'skip': true
    },
    {
      'color': '#a3e4f1',
      'title': 'Follow Latest Style Shoes',
      'image': 'asset/images/shoes3.png',
      'description':
          'There Are Many Beautiful & Attractive Plants To Your Room',
      'skip': true
    },
    {
      'color': '#31b77a',
      'title': 'Summer Shoes 2024',
      'image': 'asset/images/shoes2.png',
      'description':
          'Are you ready to make a dish for your friends or family? create an account and cooks',
      'skip': false
    },
  ];
  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    } else {
      if (_activePage == 2) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Introscreen(
                  color: _pages[index]['color'],
                  title: _pages[index]['title'],
                  description: _pages[index]['description'],
                  image: _pages[index]['image'],
                  skip: _pages[index]['skip'],
                  onTab: onNextPage,
                );
              }),
          Positioned(
            bottom: 25,
            left: 30,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator())
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            right: 20,
            child: GestureDetector(
              onTap: () {
                onNextPage();
              },
              child: Container(
                  height: 50,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: blueColor,
                  ),
                  child: _activePage == 0
                      ? "Get Started"
                          .text
                          .bold
                          .color(Colors.white)
                          .makeCentered()
                      : "Next".text.bold.color(Colors.white).makeCentered()),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

// Changes colors based on screen
  Widget _indicatorsTrue() {
    //Active Indicator
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: blueColor,
      ),
    );
  }

//Inactive Indicator
  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFFE5EEF7),
      ),
    );
  }
}

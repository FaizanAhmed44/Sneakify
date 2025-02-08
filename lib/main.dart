import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/adminbottomnavigation/admin_bottom_nav.dart';
import 'package:ecommerce_app/features/user/bottomnavigation/view/bottomnavigationscreen.dart';
import 'package:ecommerce_app/features/user/onboarding/view/onboarding_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

late Box box1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  box1 = await Hive.openBox('ecommerceApp');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? homeScreen; // Cache the resolved home screen

  @override
  void initState() {
    super.initState();
    _initializeHomeScreen();
  }

  Future<void> _initializeHomeScreen() async {
    final isLoggedIn = box1.get('isLogedIn', defaultValue: false) as bool;

    if (!isLoggedIn) {
      setState(() {
        homeScreen = const OnboardingScreen();
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        homeScreen = const OnboardingScreen();
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final accountType = doc.data()?['accountType'] ?? 'User';

      setState(() {
        homeScreen = accountType == 'Admin'
            ? const CustomBottomNavBarAdmin()
            : const CustomBottomNavBar();
      });
    } catch (e) {
      debugPrint('Error checking accountType: $e');
      setState(() {
        homeScreen = const OnboardingScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => TheamModal(),
      child: Consumer<TheamModal>(
        builder: (context, TheamModal theamModal, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theamModal.isDark
                ? ThemeData.dark().copyWith(
                    textTheme: GoogleFonts.poppinsTextTheme(textTheme),
                    primaryTextTheme: const TextTheme(),
                  )
                : ThemeData.light().copyWith(
                    textTheme: GoogleFonts.poppinsTextTheme(textTheme),
                    primaryTextTheme: const TextTheme(),
                  ),
            home: homeScreen ?? _buildLoadingScreen(theamModal.isDark),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen(bool isDarkTheme) {
    return Scaffold(
      body: Container(
        color: isDarkTheme ? mainColor : scaffoldColor,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

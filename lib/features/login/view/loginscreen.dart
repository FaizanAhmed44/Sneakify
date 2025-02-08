import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/adminbottomnavigation/admin_bottom_nav.dart';
import 'package:ecommerce_app/features/user/bottomnavigation/view/bottomnavigationscreen.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/features/login/view/recoverpassword.dart';
import 'package:ecommerce_app/features/login/view/signinscreen.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: emailController.text, password: passwordController.text);

    if (res == 'success') {
      emailController.clear();
      passwordController.clear();
      // Fetch the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Get the account type from Firestore
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          final accountType = doc.data()?["accountType"] ?? 'User';

          // Save login status in Hive
          box1.put('isLogedIn', true);

          // Navigate to the appropriate screen
          if (accountType == 'Admin') {
            // Navigate to Admin screen
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CustomBottomNavBarAdmin(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            // Navigate to User screen
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CustomBottomNavBar(),
              ),
              (Route<dynamic> route) => false,
            );
          }
          // ignore: use_build_context_synchronously
          showSnackBar("Successfully Logged In", context);
        } catch (e) {
          // Handle error
          // ignore: use_build_context_synchronously
          showSnackBar("Error: ${e.toString()}", context);
        }
      }
    } else {
      // Show error message
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }

    setState(() {
      isLoading = false;
    });
  }

  void googleSignUp() async {
    User? user = await AuthMethods().signInWithGoogle();
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String accountType = doc.data()?['accountType'] ?? 'User';

        // Save login status in Hive
        box1.put('isLogedIn', true);

        // Navigate to the appropriate screen
        if (accountType == 'Admin') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavBarAdmin(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavBar(),
            ),
            (Route<dynamic> route) => false,
          );
        }
        // ignore: use_build_context_synchronously
        showSnackBar("User signed in: ${user.displayName}", context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar("Error: ${e.toString()}", context);
      }
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar("User sign-in failed", context);
    }
  }

  // void loginUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String res = await AuthMethods().logInUser(
  //       email: emailController.text, password: passwordController.text);
  //   if (res == 'success') {
  //     emailController.clear();
  //     passwordController.clear();
  //     // ignore: use_build_context_synchronously
  //     showSnackBar("Successfully Login", context);
  //     box1.put('isLogedIn', true);
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const CustomBottomNavBar()),
  //       (Route<dynamic> route) =>
  //           false, // This condition removes all previous routes
  //     );
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     showSnackBar(res, context);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // void googleSignUp() async {
  //   User? user = await AuthMethods().signInWithGoogle();
  //   if (user != null) {
  //     // ignore: use_build_context_synchronously
  //     showSnackBar("User signed in: ${user.displayName}", context);
  //     box1.put('isLogedIn', true);
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const CustomBottomNavBar()));
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     showSnackBar("User signed in failed", context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              "Hello Again!"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(30)
                  .makeCentered(),
              "Welcome Back You've Been Missed!"
                  .text
                  .color(lightColor)
                  .size(16)
                  .make()
                  .centered(),
              const SizedBox(
                height: 70,
              ),
              "Email Address"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make(),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "e.g faizan@gmail.com",
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              "Password"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make(),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        controller: passwordController,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        decoration: const InputDecoration(
                          hintText: "e.g faizan123",
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 154, 154, 154)),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          // suffixIcon: Icon(CupertinoIcons.eye_slash),
                          // suffix: Icon(CupertinoIcons.eye_slash),
                        ),
                        obscureText: isObscure,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: isObscure
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RecoverPassword()));
                    },
                    child: "Recover Password"
                        .text
                        .color(lightColor)
                        .size(13)
                        .make()),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  loginUser();
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => const CustomBottomNavBar(),
                  //   ),
                  // );
                },
                child: Container(
                  height: 58,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9EE1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ).centered()
                      : "Sign In"
                          .text
                          .color(Colors.white)
                          .size(18)
                          .bold
                          .make()
                          .centered(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  googleSignUp();
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/images/google.png",
                        width: 34,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      "Sign in with google"
                          .text
                          .color(
                              theamNotifier.isDark ? Colors.white : mainColor)
                          .size(17)
                          .bold
                          .make()
                          .centered(),
                    ],
                  ),
                ),
              ),
              // Flexible(flex: 1, child: Container()),
              const SizedBox(
                height: 110,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                      text: "Don't Have An Account?",
                      style: const TextStyle(color: lightColor, fontSize: 13),
                      children: [
                        TextSpan(
                            text: " Sign Up For Free",
                            style: TextStyle(
                                color: theamNotifier.isDark
                                    ? Colors.white
                                    : mainColor,
                                fontWeight: FontWeight.bold))
                      ]),
                ).centered(),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ).px20(),
        ),
      );
    });
  }
}

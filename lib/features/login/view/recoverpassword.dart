import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor:
            theamNotifier.isDark ? mainColor : const Color(0xFFF5F5F5),
        // backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Recovery Password',
              style: TextStyle(
                color: theamNotifier.isDark ? Colors.white : mainColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).centered(),
            const SizedBox(height: 10),
            const Text(
              'Please Enter Your Email Address To\nReceive a Verification Code',
              textAlign: TextAlign.center, // To align the text centrally
              style: TextStyle(
                color: lightColor, // Light grey text color
                fontSize: 16,
              ),
            ).centered(),
            const SizedBox(
              height: 50,
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
                decoration: const InputDecoration(
                  hintText: "e.g Faizan64@gmail.com",
                  hintStyle: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF5B9EE1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: "Continue"
                  .text
                  .color(Colors.white)
                  .size(18)
                  .bold
                  .make()
                  .centered(),
            ),
          ],
        ).px20(),
      );
    });
  }
}

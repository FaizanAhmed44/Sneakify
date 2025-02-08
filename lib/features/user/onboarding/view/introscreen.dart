import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Introscreen extends StatelessWidget {
  final String color;
  final String title;
  final String description;
  final String image;
  final bool skip;
  final VoidCallback onTab;
  const Introscreen({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.image,
    required this.skip,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.62,
              // color: Colors.black26,
              child: Stack(
                children: [
                  // Positioned(
                  //   top: 300,
                  //   left: 0,
                  //   right: 0,
                  //   child: Transform.rotate(
                  //     angle: 11 / 4,
                  //     child: Container(
                  //       width: 20,
                  //       height: 100,
                  //       // margin:
                  //       //     const EdgeInsets.only(top: 265, left: 00, right: 70),
                  //       decoration: const BoxDecoration(
                  //         // shape: BoxShape.re,
                  //         gradient: RadialGradient(colors: [
                  //           Color.fromARGB(95, 0, 0, 0),
                  //           Color.fromARGB(54, 19, 19, 19),
                  //           // Color(0xffF8F9FA)
                  //         ]),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                      top: -90,
                      // left: 0,
                      right: -90,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                stops: theamNotifier.isDark
                                    ? const [0, 1]
                                    : const [0, 1],
                                colors: theamNotifier.isDark
                                    ? [
                                        mainDarkColor,
                                        mainColor
                                        // Colors.white
                                      ]
                                    : [
                                        Colors.blue.shade100,
                                        const Color(0xffF8F9FA),
                                        // Colors.white
                                      ])),
                      )),
                  Positioned(
                      top: -50,
                      // left: 0,
                      right: -50,
                      child: Container(
                        width: 155,
                        height: 155,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theamNotifier.isDark
                                ? mainColor
                                : Colors.white),
                      )),
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: "NIKE"
                        .text
                        .color(theamNotifier.isDark
                            ? mainDarkColor
                            : const Color.fromARGB(246, 239, 239, 239))
                        .bold
                        .size(170)
                        .makeCentered(),
                  ),
                  Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Image.asset(image),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 40,
                    // right: 0,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: blueColor),
                    ),
                  ),
                  Positioned(
                    bottom: 110,
                    // left: ,
                    right: 35,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: blueColor),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 50,
                    // right: 30,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              theamNotifier.isDark ? mainDarkColor : blueColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            title
                .toString()
                .text
                .bold
                .color(theamNotifier.isDark ? Colors.white : mainColor)
                .size(40)
                .make()
                .px(24),
            // Text(
            //   title,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 40,
            //       color: theamNotifier.isDark ? Colors.white : mainColor),
            // ).px16(),
            const SizedBox(
              height: 17,
            ),
            description
                .toString()
                .text
                .color(lightColor)
                .size(18)
                .make()
                .px(24),
            const SizedBox(
              height: 17,
            ),
          ],
        ),
      );
    });
  }
}

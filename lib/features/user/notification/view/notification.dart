import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: theamNotifier.isDark ? mainColor : scaffoldColor,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Notification"
                  .text
                  .color(theamNotifier.isDark ? Colors.white : Colors.black)
                  .bold
                  .make(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    theamNotifier.isDark = !theamNotifier.isDark;
                  });
                },
                child: theamNotifier.isDark
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            "Today"
                .text
                .bold
                .size(20)
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .make(),
            const SizedBox(
              height: 6,
            ),
            ListView.builder(
                itemCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 100,
                    // decoration: const BoxDecoration(color: Colors.black12),
                    child: Row(
                      children: [
                        Container(
                          width: 85,
                          height: 80,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white,
                          ),
                          child: Image.asset(
                              "asset/images/shoes${8 + index + 2}.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "we have new product with offers",
                                style: TextStyle(
                                    color: theamNotifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  "\$345.00"
                                      .text
                                      .bold
                                      .size(12)
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .make(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  "\$245.00"
                                      .text
                                      .size(10)
                                      .bold
                                      .color(lightColor)
                                      .make(),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "${6 + index} min ago",
                                  style: const TextStyle(
                                      color: lightColor, fontSize: 11),
                                ).pOnly(top: 15),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: blueColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            "Yesterday"
                .text
                .bold
                .size(20)
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .make(),
            const SizedBox(
              height: 6,
            ),
            ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 85,
                          height: 80,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white,
                          ),
                          child: Image.asset("asset/images/shoes2.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "we have new product with offers",
                                style: TextStyle(
                                    color: theamNotifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  "\$345.00"
                                      .text
                                      .bold
                                      .size(12)
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .make(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  "\$245.00"
                                      .text
                                      .size(10)
                                      .bold
                                      .color(lightColor)
                                      .make(),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "${6 + index} min ago",
                                  style: const TextStyle(
                                      color: lightColor, fontSize: 11),
                                ).pOnly(top: 15),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: blueColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ).px16(),
      );
    });
  }
}

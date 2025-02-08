import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/help_center/view/helpcenter_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitch1 = false;
  bool isSwitch2 = false;
  bool isSwitch3 = false;
  bool isSwitch4 = false;
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
              "App Settings"
                  .text
                  .size(19)
                  .color(theamNotifier.isDark ? Colors.white : Colors.black)
                  .bold
                  .make(),
            ],
          ),
        ),
        body: ListView(
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
            // "Account"
            //     .text
            //     .bold
            //     .size(19)
            //     .color(theamNotifier.isDark ? Colors.white : Colors.black)
            //     .make(),
            // const SizedBox(
            //   height: 25,
            // ),
            // columnDef(
            //     theamNotifier,
            //     "Notification Setting",
            //     Icons.notifications_active_outlined,
            //     Icons.arrow_forward_ios_outlined),
            // const SizedBox(
            //   height: 15,
            // ),
            // columnDef(theamNotifier, "Shipping Address",
            //     FluentIcons.cart_24_regular, Icons.arrow_forward_ios_outlined),
            // const SizedBox(
            //   height: 15,
            // ),
            // columnDef(
            //     theamNotifier,
            //     "Payment Info",
            //     FluentIcons.payment_24_regular,
            //     Icons.arrow_forward_ios_outlined),
            // const SizedBox(
            //   height: 15,
            // ),
            // columnDef(
            //     theamNotifier,
            //     "Delete Account",
            //     FluentIcons.delete_24_regular,
            //     Icons.arrow_forward_ios_outlined),
            const SizedBox(
              height: 15,
            ),
            //pack1
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Enable Face ID For Log In"
                        .text
                        .size(16)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                      ).copyWith(
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(outline: Colors.transparent),
                      ),
                      child: Switch(
                          activeColor: Colors.white,
                          activeTrackColor: blueColor,
                          inactiveTrackColor: theamNotifier.isDark
                              ? mainDarkColor
                              : switchLightColor,
                          inactiveThumbColor: Colors.white,
                          value: isSwitch1,
                          onChanged: (onChanged) {
                            setState(() {
                              isSwitch1 = onChanged;
                            });
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Divider(
                  thickness: 2,
                  color: theamNotifier.isDark ? mainDarkColor : lineColor,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            //pack2
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Enable Push Notifications"
                        .text
                        .size(16)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                      ).copyWith(
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(outline: Colors.transparent),
                      ),
                      child: Switch(
                          activeColor: Colors.white,
                          activeTrackColor: blueColor,
                          inactiveTrackColor: theamNotifier.isDark
                              ? mainDarkColor
                              : switchLightColor,
                          inactiveThumbColor: Colors.white,
                          value: isSwitch2,
                          onChanged: (onChanged) {
                            setState(() {
                              isSwitch2 = onChanged;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Divider(
                  thickness: 2,
                  color: theamNotifier.isDark ? mainDarkColor : lineColor,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            //pack3
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Enable Location Services"
                        .text
                        .size(16)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                      ).copyWith(
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(outline: Colors.transparent),
                      ),
                      child: Switch(
                          activeColor: Colors.white,
                          activeTrackColor: blueColor,
                          inactiveTrackColor: theamNotifier.isDark
                              ? mainDarkColor
                              : switchLightColor,
                          inactiveThumbColor: Colors.white,
                          value: isSwitch3,
                          onChanged: (onChanged) {
                            setState(() {
                              isSwitch3 = onChanged;
                            });
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Divider(
                  thickness: 2,
                  color: theamNotifier.isDark ? mainDarkColor : lineColor,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            //pack4
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Dark Mode"
                        .text
                        .size(16)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                      ).copyWith(
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(outline: Colors.transparent),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            theamNotifier.isDark = !theamNotifier.isDark;
                          });
                        },
                        child: theamNotifier.isDark
                            ? const Icon(
                                Icons.light_mode,
                                color: switchLightColor,
                              )
                            : const Icon(
                                Icons.dark_mode,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                      ).px12(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Divider(
                  thickness: 2,
                  color: theamNotifier.isDark ? mainDarkColor : lineColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HelpScreen()));
                  },
                  child: SizedBox(
                    width: double.maxFinite,
                    child: "Help Center"
                        .text
                        .size(16)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Divider(
                  thickness: 2,
                  color: theamNotifier.isDark ? mainDarkColor : lineColor,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ).px20(),
      );
    });
  }

  Widget settingRow(
      TheamModal theamNotifier, bool isSwitch1, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Enable Face ID For Log In"
                .text
                .size(16)
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .make(),
            Switch(
                value: isSwitch1,
                onChanged: (onChanged) {
                  setState(() {
                    isSwitch1 = onChanged;
                  });
                })
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 2,
          color: lineColor,
        )
      ],
    );
  }

  // Widget columnDef(
  //     TheamModal theamNotifier, String name, IconData icon1, IconData icon2) {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 icon1,
  //                 color: lightColor,
  //               ),
  //               const SizedBox(
  //                 width: 20,
  //               ),
  //               name.text
  //                   .size(16)
  //                   .color(theamNotifier.isDark ? Colors.white : Colors.black)
  //                   .make(),
  //             ],
  //           ),
  //           Icon(
  //             icon2,
  //             color: lightColor,
  //             size: 17,
  //           ),
  //         ],
  //       ),
  //       const SizedBox(
  //         height: 10,
  //       ),
  //       Divider(
  //         thickness: 2,
  //         color: theamNotifier.isDark ? mainDarkColor : lineColor,
  //       )
  //     ],
  //   );
  // }
}

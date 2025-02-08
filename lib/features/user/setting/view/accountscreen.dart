import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
              "Account"
                  .text
                  .size(19)
                  .color(theamNotifier.isDark ? Colors.white : Colors.black)
                  .bold
                  .make(),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            columnDef(
                theamNotifier,
                "Notification Setting",
                Icons.notifications_active_outlined,
                Icons.arrow_forward_ios_outlined),
            const SizedBox(
              height: 15,
            ),
            columnDef(theamNotifier, "Shipping Address",
                FluentIcons.cart_24_regular, Icons.arrow_forward_ios_outlined),
            const SizedBox(
              height: 15,
            ),
            columnDef(
                theamNotifier,
                "Payment Info",
                FluentIcons.payment_24_regular,
                Icons.arrow_forward_ios_outlined),
            const SizedBox(
              height: 15,
            ),
            columnDef(
                theamNotifier,
                "Delete Account",
                FluentIcons.delete_24_regular,
                Icons.arrow_forward_ios_outlined),
          ],
        ),
      );
    });
  }

  Widget columnDef(
      TheamModal theamNotifier, String name, IconData icon1, IconData icon2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon1,
                  color: lightColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                name.text
                    .size(16)
                    .color(theamNotifier.isDark ? Colors.white : Colors.black)
                    .make(),
              ],
            ),
            Icon(
              icon2,
              color: lightColor,
              size: 17,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 2,
          color: theamNotifier.isDark ? mainDarkColor : lineColor,
        )
      ],
    ).px16();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/chat/admin_chat_list_screen.dart';
import 'package:ecommerce_app/features/Admin/orders/view/order_admin_screen.dart';
import 'package:ecommerce_app/features/user/editprofile/view/editprofilescreen.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/features/login/view/loginscreen.dart';
import 'package:ecommerce_app/features/user/setting/view/settingscreen.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/screen/upload_data_screen.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreenAdmin extends StatefulWidget {
  const ProfileScreenAdmin({super.key});

  @override
  State<ProfileScreenAdmin> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreenAdmin> {
  DocumentSnapshot? user;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    setState(() {});
  }

  Widget shimmerPlaceholder(
      double screenWidth, double screenHeight, TheamModal theamNotifier) {
    return Shimmer.fromColors(
      baseColor: theamNotifier.isDark
          ? mainDarkColor.withOpacity(0.2)
          : Colors.grey[300]!,
      highlightColor:
          theamNotifier.isDark ? Colors.grey[50]! : Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.10),
          Container(
            width: screenWidth * 0.15,
            height: screenWidth * 0.15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.025,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              const Icon(FluentIcons.hand_wave_20_filled,
                  color: Color(0xFFFEC837)),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            width: screenWidth * 0.4,
            height: screenHeight * 0.03,
            color: Colors.black,
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.030,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.025,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.030,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.030,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.030,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.030,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: screenWidth * 0.3,
                height: screenHeight * 0.030,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ).px16(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        body: user == null
            ? Center(
                child: shimmerPlaceholder(
                    screenWidth, screenHeight, theamNotifier),
              )
            : Row(
                children: [
                  SizedBox(
                    height: screenHeight * 0.9,
                    width: screenWidth * 0.56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.08),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (user!.data()
                                              as dynamic)['profileUrl'] ==
                                          ""
                                      ? const AssetImage(
                                          "asset/images/profile.png")
                                      : NetworkImage((user!.data()
                                              as dynamic)['profileUrl'])
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              children: [
                                "Hey, "
                                    .text
                                    .color(lightColor)
                                    .size(screenWidth * 0.045)
                                    .make()
                                    .px4(),
                                const Icon(
                                  FluentIcons.hand_wave_20_filled,
                                  color: Color(0xFFFEC837),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            "${(user!.data() as dynamic)['userName']}"
                                .text
                                .bold
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .size(screenWidth * 0.055)
                                .make()
                                .px4(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen()))
                                .then((v) {
                              getUserDetail();
                            });
                          },
                          child: _buildMenuOption(
                            icon: FluentIcons.person_24_regular,
                            label: "Profile",
                            fontSize: screenWidth * 0.04,
                            theamNotifier: theamNotifier,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const OrderAdminScreen()));
                          },
                          child: _buildMenuOption(
                            icon: FluentIcons.shopping_bag_24_regular,
                            label: "Orders",
                            fontSize: screenWidth * 0.04,
                            theamNotifier: theamNotifier,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddProduct()));
                          },
                          child: _buildMenuOption(
                            icon: FluentIcons.add_24_regular,
                            label: "Upload",
                            fontSize: screenWidth * 0.04,
                            theamNotifier: theamNotifier,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingScreen()));
                          },
                          child: _buildMenuOption(
                            icon: FluentIcons.settings_24_regular,
                            label: "Settings",
                            fontSize: screenWidth * 0.04,
                            theamNotifier: theamNotifier,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AdminChatListScreen(
                                      adminId: '18Vuzf09uFRCZ90mqa0gyzzCtq53',
                                    )));
                          },
                          child: _buildMenuOption(
                            icon: FluentIcons.chat_24_regular,
                            label: "Manage Chats",
                            fontSize: screenWidth * 0.04,
                            theamNotifier: theamNotifier,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(thickness: 0.8, color: lightColor),
                            SizedBox(height: screenHeight * 0.028),
                            GestureDetector(
                              onTap: () {
                                AuthMethods().signOut();
                                box1.put('isLogedIn', false);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: _buildMenuOption(
                                icon: FluentIcons.sign_out_24_regular,
                                label: "Sign Out",
                                fontSize: screenWidth * 0.04,
                                theamNotifier: theamNotifier,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.08),
                          ],
                        ),
                      ],
                    ).pOnly(left: screenWidth * 0.07),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.1,
                      bottom: screenHeight * 0.06,
                      right: 0,
                    ),
                    child: theamNotifier.isDark
                        ? Image.asset(
                            "asset/images/profileImg.png",
                            fit: BoxFit.fitHeight,
                          )
                        : Image.asset(
                            "asset/images/profileImgdark.png",
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required double fontSize,
    required TheamModal theamNotifier,
  }) {
    return Row(
      children: [
        Icon(icon, color: lightColor),
        SizedBox(width: fontSize * 0.8),
        label.text.bold
            .color(theamNotifier.isDark ? Colors.white : Colors.black)
            .size(fontSize)
            .make(),
      ],
    );
  }
}

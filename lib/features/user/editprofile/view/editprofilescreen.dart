import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/address/view/addressscreen.dart';
import 'package:ecommerce_app/features/user/editprofile/methods/usermethods.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;
  DocumentSnapshot? user;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(
      source: source,
    );

    if (file != null) {
      return await file.readAsBytes();
    }
  }

  void getUserDetail() async {
    // userModel =
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    setState(() {});
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Edit profile"
              .text
              .size(19)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make(),
          centerTitle: false,
          actions: [
            image != null
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await UserMethods().updateUserImage(
                          file: image!,
                          uid: FirebaseAuth.instance.currentUser!.uid);

                      image = null;
                      getUserDetail();
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Icon(
                      Icons.done,
                      color: Colors.blue,
                      size: 30,
                    ).px16(),
                  )
                : Container(),
            (nameController.text.isNotEmpty ||
                    ageController.text.isNotEmpty ||
                    phoneController.text.isNotEmpty)
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (nameController.text.isEmpty) {
                        nameController.text =
                            (user!.data() as dynamic)['userName'];
                      }
                      if (ageController.text.isEmpty) {
                        ageController.text = (user!.data() as dynamic)['age'];
                      }
                      if (phoneController.text.isEmpty) {
                        phoneController.text =
                            (user!.data() as dynamic)['phoneNumber'];
                      }
                      await UserMethods().updateUserInfo(
                        age: ageController.text,
                        phone: phoneController.text,
                        name: nameController.text,
                        uid: FirebaseAuth.instance.currentUser!.uid,
                      );
                      getUserDetail();

                      setState(() {
                        isLoading = false;
                        nameController.text = '';
                        ageController.text = '';
                        phoneController.text = '';
                      });
                    },
                    child: const Icon(
                      Icons.done,
                      color: Colors.blue,
                      size: 30,
                    )).px16()
                : Container(),
          ],
        ),
        body: user == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading ? const LinearProgressIndicator() : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 115,
                      height: 125,
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: image == null
                                    ? (user!.data() as dynamic)['profileUrl'] ==
                                            ""
                                        ? const AssetImage(
                                            "asset/images/profile.png")
                                        : NetworkImage((user!.data()
                                            as dynamic)['profileUrl'])
                                    : MemoryImage(image!),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 40,
                            child: GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: blueColor,
                                child: const Icon(
                                  size: 19,
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ).centered(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).centered(),
                    // Center(
                    //   child: CircleAvatar(
                    //     backgroundImage: image == null
                    //         ? (user!.data() as dynamic)['profileUrl'] == ""
                    //             ? const AssetImage("asset/images/profile.png")
                    //             : NetworkImage(
                    //                 (user!.data() as dynamic)['profileUrl'])
                    //         : MemoryImage(image!),
                    //     radius: 55,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 17,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     selectImage();
                    //   },
                    //   child: "Edit profile picture"
                    //       .text
                    //       .color(Colors.blue)
                    //       .size(17)
                    //       .bold
                    //       .makeCentered(),
                    // ),
                    const SizedBox(
                      height: 27,
                    ),
                    "Full Name"
                        .text
                        .bold
                        .color(theamNotifier.isDark ? Colors.white : mainColor)
                        .size(16)
                        .make()
                        // .px(6)
                        .px(22),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            theamNotifier.isDark ? mainDarkColor : Colors.white,
                      ),
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        // controller: emailController,
                        decoration: InputDecoration(
                          hintText: (user!.data() as dynamic)['userName'],
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 154, 154, 154)),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (val) {
                          setState(() {});
                        },
                      ),
                    ).px16(),
                    // "Username"
                    //     .text
                    //     .color(
                    //         theamNotifier.isDark ? Colors.white : Colors.black)
                    //     .size(15)
                    //     .make()
                    //     .px16(),
                    // const SizedBox(
                    //   height: 0,
                    // ),
                    // TextFormField(
                    //   controller: nameController,
                    //   style: TextStyle(
                    //       color: theamNotifier.isDark
                    //           ? const Color.fromARGB(132, 255, 255, 255)
                    //           : Colors.black),
                    //   decoration: InputDecoration(
                    //     hintStyle: TextStyle(
                    //         color: theamNotifier.isDark
                    //             ? const Color.fromARGB(132, 255, 255, 255)
                    //             : Colors.black),
                    //     // hintText: user.username,
                    //     hintText: (user!.data() as dynamic)['userName'],
                    //   ),
                    //   onFieldSubmitted: (val) {
                    //     setState(() {});
                    //   },
                    // ).px16(),
                    const SizedBox(
                      height: 20,
                    ),
                    "Email Address"
                        .text
                        .bold
                        .color(theamNotifier.isDark ? Colors.white : mainColor)
                        .size(16)
                        .make()
                        .px(22),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            theamNotifier.isDark ? mainDarkColor : Colors.white,
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        // controller: emailController,
                        decoration: InputDecoration(
                          hintText: (user!.data() as dynamic)['email'],
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 154, 154, 154)),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                    ).px16(),

                    const SizedBox(
                      height: 20,
                    ),
                    "Age"
                        .text
                        .bold
                        .color(theamNotifier.isDark ? Colors.white : mainColor)
                        .size(16)
                        .make()
                        .px(22),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            theamNotifier.isDark ? mainDarkColor : Colors.white,
                      ),
                      child: TextFormField(
                        controller: ageController,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        // controller: emailController,
                        decoration: InputDecoration(
                          hintText: (user!.data() as dynamic)['age'] == ""
                              ? "e.g   (20, 15, 21)"
                              : (user!.data() as dynamic)['age'],
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 154, 154, 154)),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (val) {
                          setState(() {});
                        },
                      ),
                    ).px16(),
                    // "Age"
                    //     .text
                    //     .color(
                    //         theamNotifier.isDark ? Colors.white : Colors.black)
                    //     .size(15)
                    //     .make()
                    //     .px16(),
                    // const SizedBox(
                    //   height: 0,
                    // ),
                    // TextFormField(
                    //   controller: ageController,
                    //   style: TextStyle(
                    //       color: theamNotifier.isDark
                    //           ? const Color.fromARGB(132, 255, 255, 255)
                    //           : Colors.black),
                    //   decoration: InputDecoration(
                    //     hintStyle: TextStyle(
                    //         color: theamNotifier.isDark
                    //             ? const Color.fromARGB(132, 255, 255, 255)
                    //             : Colors.black),
                    //     // hintText: user.bio,
                    //     hintText: (user!.data() as dynamic)['age'] == ""
                    //         ? "e.g   (20, 15, 21)"
                    //         : (user!.data() as dynamic)['age'],
                    //   ),
                    //   onFieldSubmitted: (val) {
                    //     setState(() {});
                    //   },
                    // ).px16(),
                    const SizedBox(
                      height: 20,
                    ),
                    "Phone Number"
                        .text
                        .bold
                        .color(theamNotifier.isDark ? Colors.white : mainColor)
                        .size(16)
                        .make()
                        .px(22),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            theamNotifier.isDark ? mainDarkColor : Colors.white,
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        // controller: emailController,
                        decoration: InputDecoration(
                          hintText:
                              (user!.data() as dynamic)['phoneNumber'] == ""
                                  ? "e.g 92 306 2860258"
                                  : (user!.data() as dynamic)['phoneNumber'],
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 154, 154, 154)),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (val) {
                          setState(() {});
                        },
                      ),
                    ).px16(),
                    const SizedBox(
                      height: 20,
                    ),
                    // "Address"
                    //     .text
                    //     .bold
                    //     .color(theamNotifier.isDark ? Colors.white : mainColor)
                    //     .size(16)
                    //     .make()
                    //     .px(22),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color:
                    //         theamNotifier.isDark ? mainDarkColor : Colors.white,
                    //   ),
                    //   child: TextFormField(
                    //     controller: addressController,
                    //     style: const TextStyle(
                    //         fontSize: 14,
                    //         color: Color.fromARGB(255, 154, 154, 154)),
                    //     // controller: emailController,
                    //     decoration: InputDecoration(
                    //       hintText: (user!.data() as dynamic)['address'] == ""
                    //           ? "e.g Gulshan Block 2"
                    //           : (user!.data() as dynamic)['address'],
                    //       hintStyle: const TextStyle(
                    //           fontSize: 14,
                    //           color: Color.fromARGB(255, 154, 154, 154)),
                    //       disabledBorder: InputBorder.none,
                    //       enabledBorder: InputBorder.none,
                    //       border: InputBorder.none,
                    //     ),
                    //     onFieldSubmitted: (val) {
                    //       setState(() {});
                    //     },
                    //   ),
                    // ).px16(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const AddressSelectionScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: "Address"
                            .text
                            .color(Colors.white)
                            .size(15.5)
                            .bold
                            .make()
                            .centered(),
                      ),
                    ).px(20),
                  ],
                ),
              ),
      );
    });
  }
}

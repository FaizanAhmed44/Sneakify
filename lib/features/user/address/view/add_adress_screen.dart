import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/editprofile/methods/usermethods.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({super.key});

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();
  bool isDefault = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    addressDetailController.dispose();
    addressNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theamNotifier.isDark ? mainColor : scaffoldColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber line
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Address Details",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: lightColor,
                thickness: 0.7,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Address Name"
                      .text
                      .bold
                      .color(theamNotifier.isDark ? Colors.white : mainColor)
                      .size(16)
                      .make()
                      .px(8),
                  const SizedBox(
                    height: 13,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 3.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                    ),
                    child: TextFormField(
                      controller: addressNameController,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 154, 154, 154)),
                      // controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "e.g   Home, Office",
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Address Detail"
                      .text
                      .bold
                      .color(theamNotifier.isDark ? Colors.white : mainColor)
                      .size(16)
                      .make()
                      .px(8),
                  const SizedBox(
                    height: 13,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 3.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                    ),
                    child: TextFormField(
                      controller: addressDetailController,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 154, 154, 154)),
                      // controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "e.g   E-31 Gulshan Block 2, Karachi",
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 154, 154, 154)),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      activeColor:
                          theamNotifier.isDark ? Colors.white : Colors.black,
                      checkColor:
                          theamNotifier.isDark ? Colors.black : Colors.white,
                      value: isDefault,
                      onChanged: (bool? value) {
                        setState(() {
                          isDefault = value!;
                        });
                      }),
                  const SizedBox(
                    width: 5,
                  ),
                  "Mark this as the default address"
                      .text
                      .color(theamNotifier.isDark ? Colors.white : Colors.black)
                      .size(14)
                      .make()
                      .pOnly(bottom: 3),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (addressDetailController.text.isNotEmpty &&
                      addressNameController.text.isNotEmpty) {
                    Map<String, String> newAddress = {
                      "addressName": addressNameController.text,
                      "addressDetail": addressDetailController.text,
                    };
                    await UserMethods().addAddressAndSetDefault(
                        newAddress: newAddress, isDefault: isDefault);

                    addressDetailController.clear();
                    addressNameController.clear();
                    setState(() {});
                  } else {
                    showSnackBar("Please filled all fields!", context);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Container(
                  height: 52,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ).centered()
                      : "Add"
                          .text
                          .color(Colors.white)
                          .size(19)
                          .bold
                          .make()
                          .centered(),
                ),
              ).px4(),
            ],
          ),
        ),
      );
    });
  }
}

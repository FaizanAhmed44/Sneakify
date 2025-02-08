// import 'package:flutter/material.dart';

// class AddressSelectionScreen extends StatefulWidget {
//   @override
//   _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
// }

// class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
//   // List of address labels and their respective details
//   final List<Map<String, String>> addresses = [
//     {'label': 'Home', 'address': '61480 Sunbrook Park, PC 5679'},
//     {'label': 'Office', 'address': '6993 Meadow Valley Terra, PC 3637'},
//     {'label': 'Apartment', 'address': '21833 Clyde Gallagher, PC 4662'},
//     {'label': 'Parent\'s House', 'address': '5259 Blue Bill Park, PC 4627'},
//   ];

//   // Variable to hold the selected address index
//   int? selectedAddressIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shipping Address'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: addresses.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     color: selectedAddressIndex == index
//                         ? Colors.grey[850]
//                         : Colors.grey[800],
//                     child: RadioListTile(
//                       title: Text(
//                         addresses[index]['label']!,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         addresses[index]['address']!,
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                       value: index,
//                       groupValue: selectedAddressIndex,
//                       onChanged: (int? value) {
//                         setState(() {
//                           selectedAddressIndex = value;
//                         });
//                       },
//                       activeColor: Colors.white,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle address selection confirmation
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text('Apply'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Handle new address addition
//         },
//         label: Text('Add New Address'),
//         icon: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/address/view/add_adress_screen.dart';
import 'package:ecommerce_app/features/user/editprofile/methods/usermethods.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});
  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  DocumentSnapshot? user;
  int selectedAddressIndex = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    // userModel =
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    selectedAddressIndex = (user!.data() as dynamic)['selectedAddressIndex'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Shipping Address"
              .text
              .size(19.9)
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .bold
              .make(),
        ),
        body: user == null
            ? const CircularProgressIndicator(
                color: blueColor,
              ).centered()
            : Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 17, right: 17, bottom: 10),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: (user!.data() as dynamic)['address'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: theamNotifier.isDark
                              ? mainDarkColor
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: theamNotifier.isDark
                                      ? const Color.fromARGB(149, 83, 93, 102)
                                      : switchLightColor,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: theamNotifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    child: Icon(
                                      FluentIcons.location_28_filled,
                                      size: 21,
                                      color: theamNotifier.isDark
                                          ? Colors.black
                                          : Colors.white,
                                    ).p4().centered(),
                                  ).centered(),
                                ).p4().centered(),
                                const SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (user!.data() as dynamic)['address']
                                          [index]['addressName'],
                                      style: TextStyle(
                                        color: theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      (user!.data() as dynamic)['address']
                                          [index]['addressDetail'],
                                      style: const TextStyle(
                                        color: lightColor,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Radio<int>(
                                  value: index,
                                  groupValue: selectedAddressIndex,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedAddressIndex = value!;
                                    });
                                  },
                                  activeColor: theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          isScrollControlled:
                              true, // This allows the bottom sheet to take full height
                          builder: (BuildContext context) {
                            return const AddAddressBottomSheet();
                          },
                        ).then((v) {
                          setState(() {
                            getUserDetail();
                          });
                        });
                      },
                      child: Container(
                        height: 60,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: theamNotifier.isDark
                              ? const Color.fromARGB(149, 83, 93, 102)
                              : const Color.fromARGB(146, 200, 202, 204),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: "Add new Address"
                            .text
                            .color(
                              theamNotifier.isDark
                                  ? Colors.white
                                  // : const Color.fromARGB(158, 0, 0, 0))
                                  : Colors.black,
                            )
                            .size(18.5)
                            .bold
                            .make()
                            .centered(),
                      ),
                    ).px4(),
                  ],
                ),
              ),
        floatingActionButton: Container(
          width: double.maxFinite,
          // height: 65,
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border(
              top: BorderSide(
                  color: Color.fromARGB(146, 161, 172, 182), width: 1),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isLoading = true;
              });
              UserMethods().setDefaultAddress(index: selectedAddressIndex);
              setState(() {
                isLoading = false;
                getUserDetail();
              });
              showSnackBar("Default Address updated Successfully", context);
            },
            child: Container(
              height: 55,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    ).centered()
                  : "Apply"
                      .text
                      .color(Colors.white)
                      .size(20)
                      .bold
                      .make()
                      .centered(),
            ),
          ).px4(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}

import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/bottomnavigation/view/bottomnavigationscreen.dart';
import 'package:ecommerce_app/features/user/checkout/view/checkoutscreen.dart';
import 'package:ecommerce_app/features/shared/helperclass.dart';
import 'package:ecommerce_app/features/shared/sharedclass.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double subtotal = 0;
  double deliveryCost = 40.0;
  List<Map<String, dynamic>>? retrievedList;

  getTheSharedPref() async {
    retrievedList = [];
    retrievedList = await SharedPreferencesHelper().retrieveListOfMaps();
    SharedClass.updateListOfItems(retrievedList!);
    setState(() {});
  }

  ontheload() async {
    await getTheSharedPref();
    setState(() {});
  }

  subTotal() {
    subtotal = 0;
    if (retrievedList!.isEmpty) {
      return 0;
    }
    for (var item in retrievedList!) {
      double price = double.parse(item["price"]);
      int count = item["quantity"] as int;
      subtotal += price * count;
    }
    return double.parse(subtotal.toStringAsFixed(2));
  }

  totalCost() {
    return double.parse((subtotal + deliveryCost).toStringAsFixed(2));
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

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
          title: "My Cart"
              .text
              .size(18)
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .bold
              .make()
              .px4(),
        ),
        body: retrievedList == null
            ? Container()
            : retrievedList!.isEmpty
                ? Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "asset/images/imag.png",
                        width: 350,
                        height: 350,
                      ).centered(),
                      "Your Cart is Empty!"
                          .text
                          .bold
                          .color(theamNotifier.isDark
                              ? Colors.white
                              : Colors.black)
                          .size(28)
                          .makeCentered(),
                      const SizedBox(
                        height: 22,
                      ),
                      const Text(
                        'Oops, your cart is feeling a little lonely! Add some items to keep it company.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: lightColor),
                      ).px(22),
                      const SizedBox(
                        height: 28,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomBottomNavBar()),
                            (Route<dynamic> route) =>
                                false, // This condition removes all previous routes
                          );
                        },
                        child: Container(
                          height: 48,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B9EE1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: "Back To Home"
                              .text
                              .color(Colors.white)
                              .size(16)
                              .bold
                              .make()
                              .centered(),
                        ),
                      ).px(24),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.1,
                      // ),
                    ],
                  )
                : ListView.builder(
                    itemCount: retrievedList!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> map = retrievedList![index];
                      return Container(
                        width: double.maxFinite,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 10),
                        // color: blueColor,
                        child: Row(
                          children: [
                            Container(
                              width: 86,
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: theamNotifier.isDark
                                    ? mainDarkColor
                                    : Colors.white,
                              ),
                              child: Image.network(map['imageUrl']),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          map['productName'],
                                          style: TextStyle(
                                              color: theamNotifier.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            "\$${map['price']}"
                                                .text
                                                .bold
                                                .size(12)
                                                .color(theamNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .make(),
                                            'size : ${map['size']}'
                                                .toString()
                                                .text
                                                .size(13)
                                                .color(theamNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .make()
                                                .px(4),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // --map['count'];
                                                  SharedClass()
                                                      .decrementItemCount(
                                                          map['productId']);
                                                });
                                              },
                                              child: CircleAvatar(
                                                radius: 11,
                                                backgroundColor:
                                                    theamNotifier.isDark
                                                        ? mainDarkColor
                                                        : Colors.white,
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: lightColor,
                                                  size: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 14,
                                            ),
                                            "${map['quantity']}"
                                                .text
                                                .size(12.5)
                                                .color(theamNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .make(),
                                            const SizedBox(
                                              width: 14,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // map['count']++;
                                                  SharedClass()
                                                      .incrementItemCount(
                                                          map['productId']);
                                                });
                                              },
                                              child: const CircleAvatar(
                                                radius: 11,
                                                backgroundColor: blueColor,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              SharedClass().removeProduct(
                                                  map['productId']);
                                            });
                                          },
                                          child: const Icon(
                                            FluentIcons.delete_24_regular,
                                            color: lightColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     children: [
                            //       'size : ${map['size']}'
                            //           .toString()
                            //           .text
                            //           .size(13)
                            //           .color(theamNotifier.isDark
                            //               ? Colors.white
                            //               : Colors.black)
                            //           .make()
                            //           .px(4),
                            //       GestureDetector(
                            //         onTap: () {
                            //           setState(() {
                            //             SharedClass()
                            //                 .removeProduct(map['productId']);
                            //           });
                            //         },
                            //         child: const Icon(
                            //           FluentIcons.delete_24_regular,
                            //           color: lightColor,
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }).px16(),
        bottomNavigationBar: retrievedList == null
            ? Container()
            : retrievedList!.isEmpty
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Container(
                    width: double.maxFinite,
                    height: 250,
                    decoration: BoxDecoration(
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Subtotal".text.color(lightColor).make(),
                            "\$${subTotal()}"
                                .text
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .bold
                                .size(16)
                                .make(),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Shipping".text.color(lightColor).make(),
                            "\$40.0"
                                .text
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .bold
                                .size(16)
                                .make(),
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        // Divider(
                        //   color: theamNotifier.isDark ? lightColor : lightColor,
                        //   thickness: 0.3,
                        // ),
                        SizedBox(
                          height: 2,
                          width: double.maxFinite,
                          child: CustomPaint(
                            painter: DashedLinePainter(),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Total Cost"
                                .text
                                .bold
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .make(),
                            "\$${totalCost()}"
                                .text
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .bold
                                .size(17)
                                .make(),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Checkoutscreen(
                                  subTotal: subTotal(),
                                  shipping: 40,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B9EE1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: "Checkout"
                                .text
                                .color(Colors.white)
                                .size(16)
                                .bold
                                .make()
                                .centered(),
                          ),
                        ),
                      ],
                    ).px16(),
                  ),
      );
    });
  }
}

// class BottomBar extends StatefulWidget {
//   const BottomBar({super.key});

//   @override
//   State<BottomBar> createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBar> {
//   double subtotal = 0;
//   double deliveryCost = 40.0;
//   List<Map<String, dynamic>>? retrievedList;
//   getTheSharedPref() async {
//     retrievedList = await SharedPreferencesHelper().retrieveListOfMaps();
//     SharedClass.updateListOfItems(retrievedList!);
//     setState(() {});
//   }

//   ontheload() async {
//     await getTheSharedPref();
//     setState(() {});
//   }

//   subTotal() {
//     subtotal = 0;
//     if (retrievedList!.isEmpty) {
//       return 0;
//     }
//     for (var item in retrievedList!) {
//       double price = double.parse(item["price"]);
//       int count = item["count"] as int;
//       subtotal += price * count;
//     }
//     return subtotal;
//   }

//   totalCost() {
//     return subtotal + deliveryCost;
//   }

//   @override
//   void initState() {
//     super.initState();
//     ontheload();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
//       return retrievedList == null
//           ? Container()
//           : retrievedList!.isEmpty
//               ? const SizedBox(
//                   width: 0,
//                   height: 0,
//                 )
//               : Container(
//                   width: double.maxFinite,
//                   height: 250,
//                   decoration: BoxDecoration(
//                     color: theamNotifier.isDark ? mainDarkColor : Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           "Subtotal".text.color(lightColor).make(),
//                           "\$${subTotal()}"
//                               .text
//                               .color(theamNotifier.isDark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .bold
//                               .size(16)
//                               .make(),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           "Shipping".text.color(lightColor).make(),
//                           "\$40.0"
//                               .text
//                               .color(theamNotifier.isDark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .bold
//                               .size(16)
//                               .make(),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 28,
//                       ),
//                       // Divider(
//                       //   color: theamNotifier.isDark ? lightColor : lightColor,
//                       //   thickness: 0.3,
//                       // ),
//                       SizedBox(
//                         height: 2,
//                         width: double.maxFinite,
//                         child: CustomPaint(
//                           painter: DashedLinePainter(),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           "Total Cost"
//                               .text
//                               .bold
//                               .color(theamNotifier.isDark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .make(),
//                           "\$${totalCost()}"
//                               .text
//                               .color(theamNotifier.isDark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .bold
//                               .size(17)
//                               .make(),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => const Checkoutscreen(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF5B9EE1),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: "Checkout"
//                               .text
//                               .color(Colors.white)
//                               .size(16)
//                               .bold
//                               .make()
//                               .centered(),
//                         ),
//                       ),
//                     ],
//                   ).px16(),
//                 );
//     });
//   }
// }

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = lightColor
      ..strokeWidth = 0.4
      ..strokeCap = StrokeCap.round;

    var dashWidth = 5.0;
    var dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

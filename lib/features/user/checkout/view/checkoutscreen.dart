import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/address/view/addressscreen.dart';
import 'package:ecommerce_app/features/user/bottomnavigation/view/bottomnavigationscreen.dart';
import 'package:ecommerce_app/features/user/editprofile/view/editprofilescreen.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/features/user/my_order/view/my_orderscreen.dart';
import 'package:ecommerce_app/features/user/order/logic/ordermethods.dart';
import 'package:ecommerce_app/features/user/order/model/ordermodel.dart';
import 'package:ecommerce_app/features/shared/helperclass.dart';
import 'package:ecommerce_app/features/shared/sharedclass.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class Checkoutscreen extends StatefulWidget {
  final double subTotal;
  final double shipping;
  const Checkoutscreen(
      {super.key, required this.subTotal, required this.shipping});

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  DocumentSnapshot? user;
  bool isLoading = false;

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

  @override
  void initState() {
    super.initState();
    getUserDetail();
    ontheload();
  }

  void getUserDetail() async {
    // userModel =
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    setState(() {});
  }

  Future<void> placeOrder() async {
    setState(() {
      isLoading = true;
    });
    String orderId = const Uuid().v1();
    final order = OrderModel(
      orderId: orderId,
      userId: (user!.data() as dynamic)['uid'],
      products: retrievedList!,
      totalAmount: (widget.subTotal + widget.shipping),
      orderStatus: 'Pending',
      paymentStatus: 'Paid',
      paymentMethod: 'Credit Card',
      shippingAddress: (user!.data() as dynamic)['address']
          [(user!.data() as dynamic)['selectedAddressIndex']]['addressDetail'],
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
      shippingFee: widget.shipping,
    );

    final orderService = OrderMethods();
    await orderService.createOrder(order);
    // print(
    //     result); // Should print 'Order placed successfully' or an error message

    setState(() {
      isLoading = false;
    });
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Checkout"
                  .text
                  .size(18)
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
        bottomNavigationBar: user == null
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Container(
                width: double.maxFinite,
                height: 250,
                decoration: BoxDecoration(
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
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
                        "\$${widget.subTotal}"
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
                        "\$${widget.shipping}"
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
                        "\$${widget.shipping + widget.subTotal}"
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
                      onTap: () async {
                        // SharedClass().removeAllProduct();
                        await placeOrder();
                        // showDialog(
                        //   // ignore: use_build_context_synchronously
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        //     return const PaymentSuccessDialog();
                        //   },
                        // );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentSuccessDialog()),
                          (Route<dynamic> route) =>
                              false, // This condition removes all previous routes
                        );
                        setState(() {});
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B9EE1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              ).centered()
                            : "Payment"
                                .text
                                .color(Colors.white)
                                .size(16)
                                .bold
                                .make()
                                .centered(),
                      ),
                    ),
                  ],
                ).px16()),
        body: user == null
            ? const CircularProgressIndicator(
                color: blueColor,
              ).centered()
            : ListView(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 0.545,
                    decoration: BoxDecoration(
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Contact Information"
                            .text
                            .bold
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .make(),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      const Icon(FluentIcons.mail_20_regular),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (user!.data() as dynamic)['email']
                                        .toString()
                                        .text
                                        .ellipsis
                                        .size(13)
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make(),
                                    "Email"
                                        .text
                                        .color(lightColor)
                                        .size(13)
                                        .make(),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen()))
                                      .then((v) {
                                    setState(() {
                                      getUserDetail();
                                    });
                                  });
                                },
                                child: const Icon(FluentIcons.edit_48_regular)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      const Icon(FluentIcons.call_24_regular),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (user!.data() as dynamic)['phoneNumber']
                                            .toString()
                                            .isEmpty
                                        ? "Enter Your Number"
                                            .text
                                            .ellipsis
                                            .size(13)
                                            .color(theamNotifier.isDark
                                                ? Colors.white
                                                : Colors.black)
                                            .make()
                                        : (user!.data()
                                                as dynamic)['phoneNumber']
                                            .toString()
                                            .text
                                            .ellipsis
                                            .size(13)
                                            .color(theamNotifier.isDark
                                                ? Colors.white
                                                : Colors.black)
                                            .make(),
                                    "Phone"
                                        .text
                                        .color(lightColor)
                                        .size(13)
                                        .make(),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen()))
                                      .then((v) {
                                    setState(() {
                                      getUserDetail();
                                    });
                                  });
                                },
                                child: const Icon(FluentIcons.edit_48_regular)),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        "Address"
                            .text
                            .bold
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .make(),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (user!.data() as dynamic)['address'].isEmpty
                                ? "Please Enter Your Address"
                                    .text
                                    .color(lightColor)
                                    .size(13)
                                    .make()
                                : (user!.data() as dynamic)['address'][(user!
                                                .data()
                                            as dynamic)['selectedAddressIndex']]
                                        ['addressDetail']
                                    .toString()
                                    .text
                                    .color(lightColor)
                                    .size(13)
                                    .make(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressSelectionScreen()))
                                    .then((v) {
                                  setState(() {
                                    getUserDetail();
                                  });
                                });
                              },
                              child: const Icon(
                                Icons.arrow_drop_down,
                                color: lightColor,
                                size: 28,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset("asset/images/map.png"),
                        const SizedBox(
                          height: 15,
                        ),
                        "Payment Method"
                            .text
                            .bold
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .make(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset("asset/images/paypal.png")
                                      .p(6),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "Paypal card"
                                        .text
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make(),
                                    "***** 0696 4629"
                                        .text
                                        .color(lightColor)
                                        .size(13)
                                        .make(),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(FluentIcons.edit_48_regular),
                          ],
                        ),
                      ],
                    ).px16().py16(),
                  ).px16(),
                ],
              ),
      );
    });
  }
}

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

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainDarkColor : scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  "asset/images/ordersuccess.png",
                  width: 300,
                  height: 350,
                ).centered(),
                Text(
                  'Thank you for your order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color:
                          theamNotifier.isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  'Your order will be delivered on time.Thank you!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: lightColor, fontSize: 17),
                ),
                const SizedBox(
                  height: 28,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const CustomBottomNavBar()),
                      (Route<dynamic> route) =>
                          false, // This condition removes all previous routes
                    );
                  },
                  child: Container(
                    height: 55,
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B9EE1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: "Back To Shopping"
                        .text
                        .color(Colors.white)
                        .size(15)
                        .bold
                        .make()
                        .centered(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyOrderScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: theamNotifier.isDark
                          ? const Color.fromARGB(149, 83, 93, 102)
                          : const Color.fromARGB(146, 200, 202, 204),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: "View Orders"
                        .text
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(15)
                        .bold
                        .make()
                        .centered(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
          // child: Column(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     const SizedBox(
          //       height: 40,
          //     ),
          //     // Success Icon or Animationsoja
          //     Container(
          //       width: 100,
          //       height: 100,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Color(0xFFDFEFFF),
          //       ),
          //       child: const Center(
          //         child: Icon(
          //           Icons.celebration,
          //           size: 50,
          //           color: Colors.amber,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 26),
          //     Text(
          //       'Your Payment Is Successfull',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: theamNotifier.isDark ? Colors.white : Colors.black,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const SizedBox(height: 26),
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).pushAndRemoveUntil(
          //           MaterialPageRoute(
          //               builder: (context) => const CustomBottomNavBar()),
          //           (Route<dynamic> route) =>
          //               false, // This condition removes all previous routes
          //         );
          //       },
          //       child: Container(
          //         height: 55,
          //         width: double.maxFinite,
          //         margin: const EdgeInsets.symmetric(horizontal: 20),
          //         decoration: BoxDecoration(
          //           color: const Color(0xFF5B9EE1),
          //           borderRadius: BorderRadius.circular(50),
          //         ),
          //         child: "Back To Shopping"
          //             .text
          //             .color(Colors.white)
          //             .size(15)
          //             .bold
          //             .make()
          //             .centered(),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 40,
          //     ),
          //   ],
          // ),
        ),
      );
    });
  }
}

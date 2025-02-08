import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/admin_methods/adminmethods.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:velocity_x/velocity_x.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-detail';
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  // final OrderModel order;
  const OrderDetailScreen({
    super.key,
    required this.snap,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  DocumentSnapshot? user;
  @override
  void initState() {
    super.initState();
    decideStatus();
    getUserDetail();
  }

  void getUserDetail() async {
    // ignore: avoid_print
    print(widget.snap['userId']);
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    // ignore: avoid_print
    print((user!.data() as dynamic)['profileUrl']);
    setState(() {});
  }

  void decideStatus() {
    if (widget.snap['orderStatus'] == 'Pending') {
      currentStep = 1;
    } else if (widget.snap['orderStatus'] == 'Completed') {
      currentStep = 2;
    } else if (widget.snap['orderStatus'] == 'Received') {
      currentStep = 3;
    } else if (widget.snap['orderStatus'] == 'Delivered') {
      currentStep = 3;
    } else {
      currentStep = 1;
    }
    setState(() {});
  }

  // !!! ONLY FOR ADMIN !!!
  void changeOrderStatus(int status) {
    String tempName;
    currentStep += 1;
    setState(() {});
    if (currentStep == 2) {
      tempName = "Completed";
    } else if (currentStep == 3) {
      tempName = "Delivered";
    } else {
      tempName = "Delivered";
    }
    // widget.snap['orderStatus'] = tempName;
    AdminMethods().changeOrderStatus(
      widget.snap['userId'],
      widget.snap['orderId'],
      tempName,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime dateTime = DateTime.parse(widget.snap['orderDate']);
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Track Order"
              .text
              .size(20)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make()
              .px4(),
        ),
        body: user == null
            ? const CircularProgressIndicator().centered()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                              i < widget.snap['products'].length;
                              i++)
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => OrderDetailScreen()));
                              },
                              child: Container(
                                  width: double.maxFinite,
                                  margin: i == 0
                                      ? const EdgeInsets.only(top: 0)
                                      : const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: theamNotifier.isDark
                                        ? mainDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 80,
                                          height: 80,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: theamNotifier.isDark
                                                ? mainColor
                                                : scaffoldColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.network(
                                              widget.snap['products'][i]
                                                  ['imageUrl'])),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            widget.snap['products'][i]
                                                    ['productName']
                                                .toString()
                                                .text
                                                .bold
                                                .size(17)
                                                .color(theamNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .ellipsis
                                                .make(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 6,
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              84, 104, 218),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    "Color"
                                                        .text
                                                        .color(lightColor)
                                                        .size(8)
                                                        .make()
                                                  ],
                                                ),
                                                Container(
                                                  height: 15,
                                                  width: 1,
                                                  color: lightColor,
                                                ),
                                                "Size = ${widget.snap['products'][i]['size']}"
                                                    .text
                                                    .color(lightColor)
                                                    .size(9)
                                                    .make(),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                '\$ ${widget.snap['products'][i]['price']}'
                                                    .text
                                                    .bold
                                                    .size(15)
                                                    .color(theamNotifier.isDark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .make(),
                                                // .px(6),
                                                "Qty: ${widget.snap['products'][i]['quantity']}"
                                                    .text
                                                    .color(lightColor)
                                                    .size(9)
                                                    .make(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 0.2,
                      color: lightColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    "Order Details"
                        .text
                        .bold
                        .size(21)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Order Date: "
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),

                              '${dateTime.day}-${dateTime.month}-${dateTime.year}'
                                  .toString()
                                  .text
                                  .color(lightColor)
                                  .make(),

                              // '${widget.snap['orderDate'].toDate().day}-${widget.snap['orderDate'].toDate().month}-${widget.snap['orderDate'].toDate().year}'
                              //     .toString()
                              //     .text
                              //     .color(lightColor)
                              //     .make()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Order Status: "
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              widget.snap['orderStatus']
                                  .toString()
                                  .text
                                  .color(lightColor)
                                  .make()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Total Amount: "
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              '\$${widget.snap['totalAmount']}'
                                  .text
                                  .color(lightColor)
                                  .make()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 0.2,
                      color: lightColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    "Tracking"
                        .text
                        .bold
                        .size(22)
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .make()
                        .px4(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Stepper(
                          currentStep: currentStep,
                          controlsBuilder: ((context, details) {
                            if ((user!.data() as dynamic)['accountType'] ==
                                    'Admin' &&
                                currentStep < 3) {
                              return GestureDetector(
                                onTap: () {
                                  changeOrderStatus(currentStep);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.013,
                                    horizontal: screenWidth * 0.09,
                                  ),
                                  decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: "Done"
                                      .text
                                      .white
                                      .bold
                                      .size(screenWidth * 0.040)
                                      .make(),
                                ),
                              ).pOnly(top: 15, right: 120);
                            }
                            return const SizedBox(); // with this nothing is show below the content
                          }),
                          steps: [
                            Step(
                              title: "Pending"
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              content: "Your order is yet to be delivered."
                                  .text
                                  .color(lightColor)
                                  .make(),
                              isActive: currentStep > 0,
                              state: currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: "Completed"
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              content:
                                  "Your order has been delivered, you are yet to sign."
                                      .text
                                      .color(lightColor)
                                      .make(),
                              isActive: currentStep > 1,
                              state: currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: "Received"
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              content:
                                  "Your order has been delivered and signed by you."
                                      .text
                                      .color(lightColor)
                                      .make(),
                              isActive: currentStep > 2,
                              state: currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: "Delivered"
                                  .text
                                  .color(theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .make(),
                              content:
                                  "Your order has been delivered and signed by you."
                                      .text
                                      .color(lightColor)
                                      .make(),
                              isActive: currentStep >= 3,
                              state: currentStep >= 3
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                          ]),
                    )
                  ],
                ).px12(),
              ),
      );
    });
  }
}

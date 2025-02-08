import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/bottomnavigation/view/bottomnavigationscreen.dart';
import 'package:ecommerce_app/features/user/leave_review/view/leave_review_screen.dart';
import 'package:ecommerce_app/features/user/my_order/view/order_detail_screen_user.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
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
              "My Order"
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: theamNotifier.isDark ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: theamNotifier.isDark ? Colors.white : Colors.black,
            indicatorWeight: 3.0,
            tabs: const [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ongoing(theamNotifier),
            completed(theamNotifier),
          ],
        ),
      );
    });
  }

  Widget ongoing(TheamModal theamNotifier) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('orders')
            .where('orderStatus', isNotEqualTo: 'Delivered')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data! as dynamic).docs.isEmpty) {
            return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "asset/images/orderemp.png",
                    width: 300,
                    height: 330,
                  ).centered(),
                  Text(
                    'Your order history is currently empty!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  ).px(8),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'Start filling it up with your past purchases to keep track of your shoe shopping journey',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lightColor, fontSize: 14),
                  ).px16(),
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
                ]);
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                    width: double.maxFinite,
                    margin: index == 0
                        ? const EdgeInsets.only(top: 25)
                        : const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theamNotifier.isDark
                                ? mainColor
                                : scaffoldColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network((snapshot.data! as dynamic)
                              .docs[index]['productDetail'][0]['imageUrl']),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (snapshot.data! as dynamic)
                                  .docs[index]['productDetail'][0]
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 6,
                                        backgroundColor:
                                            Color.fromARGB(255, 84, 104, 218),
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
                                  "Size = ${(snapshot.data! as dynamic).docs[index]['productDetail'][0]['size'].toString()}"
                                      .text
                                      .color(lightColor)
                                      .size(9)
                                      .make(),
                                  Container(
                                    height: 15,
                                    width: 1,
                                    color: lightColor,
                                  ),
                                  "Qty = ${(snapshot.data! as dynamic).docs[index]['productDetail'][0]['quantity'].toString()}"
                                      .text
                                      .color(lightColor)
                                      .size(9)
                                      .make(),
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Container(
                                height: 25,
                                width: 75,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor),
                                child: Text(
                                  "In Delivery",
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black),
                                ).centered(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (snapshot.data! as dynamic)
                                      .docs[index]['totalAmount']
                                      .toString()
                                      .text
                                      .bold
                                      .size(16)
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .make()
                                      .px4(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailScreenUser(
                                                      snap: (snapshot.data!
                                                              as dynamic)
                                                          .docs[index])))
                                          .then((v) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                        width: 90,
                                        height: 27,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: blueColor),
                                        child: const Text(
                                          "Track Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ).centered()),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              }).px16();
        });
  }

  Widget completed(TheamModal theamNotifier) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('orders')
            .where('orderStatus', isEqualTo: 'Delivered')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data! as dynamic).docs.isEmpty) {
            return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "asset/images/orderemp.png",
                    width: 300,
                    height: 300,
                  ).centered(),
                  Text(
                    'Your completed order history is currently empty!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  ).px(16),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'Start filling it up with your past purchases to keep track of your shoe shopping journey',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lightColor, fontSize: 14),
                  ).px16(),
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
                ]);
          }
          return ListView.builder(
              itemCount: (snapshot.data as dynamic).docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic)
                      .docs[index]['productDetail']
                      .length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index1) {
                    return Container(
                        width: double.maxFinite,
                        margin: index == 0
                            ? const EdgeInsets.only(top: 25)
                            : const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: theamNotifier.isDark
                              ? mainDarkColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theamNotifier.isDark
                                    ? mainColor
                                    : scaffoldColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.network(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['productDetail'][index1]['imageUrl']),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (snapshot.data! as dynamic)
                                      .docs[index]['productDetail'][index1]
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 6,
                                            backgroundColor: Color.fromARGB(
                                                255, 84, 104, 218),
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
                                      "Size = ${(snapshot.data! as dynamic).docs[index]['productDetail'][index1]['size'].toString()}"
                                          .text
                                          .color(lightColor)
                                          .size(9)
                                          .make(),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: lightColor,
                                      ),
                                      "Qty = ${(snapshot.data! as dynamic).docs[index]['productDetail'][index1]['quantity'].toString()}"
                                          .text
                                          .color(lightColor)
                                          .size(9)
                                          .make(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    height: 25,
                                    width: 75,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: theamNotifier.isDark
                                            ? mainColor
                                            : scaffoldColor),
                                    child: Text(
                                      "Completed",
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: theamNotifier.isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ).centered(),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ((snapshot.data! as dynamic).docs[index]
                                                      ['productDetail'][index1]
                                                  ['quantity'] *
                                              double.parse(
                                                  (snapshot.data! as dynamic)
                                                              .docs[index]
                                                          ['productDetail']
                                                      [index1]['price']))
                                          .toString()
                                          .text
                                          .bold
                                          .size(16)
                                          .color(theamNotifier.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .make()
                                          .px(6),
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
                                              return LeaveReviewBottomSheet(
                                                  products: (snapshot.data!
                                                                  as dynamic)
                                                              .docs[index]
                                                          ['productDetail']
                                                      [index1]);
                                            },
                                          );
                                        },
                                        child: Container(
                                            width: 90,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                color: blueColor),
                                            child: const Text(
                                              "Leave Review",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                            ).centered()),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                );
              }).px16();
        });
  }
}

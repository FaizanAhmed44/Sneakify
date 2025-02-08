import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/order_detail/orderdetail_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderAdminScreen extends StatefulWidget {
  const OrderAdminScreen({super.key});

  @override
  State<OrderAdminScreen> createState() => _OrderAdminScreenState();
}

class _OrderAdminScreenState extends State<OrderAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Order Management"
              .text
              .size(20)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make()
              .px4(),
          bottom: TabBar(
            controller: _tabController,
            labelColor: theamNotifier.isDark ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: theamNotifier.isDark ? Colors.white : Colors.black,
            indicatorWeight: 3.0,
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ongoing(theamNotifier),
            cancelled(theamNotifier),
            delivered(theamNotifier),
          ],
        ),
      );
    });
  }

  Widget ongoing(TheamModal theamNotifier) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("orders")
            .where('orderStatus', isNotEqualTo: 'Delivered')
            // .orderBy('orderDate)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data! as dynamic).docs.isEmpty) {
            return Column(children: [
              const SizedBox(
                height: 31,
              ),
              Image.asset(
                "asset/images/orderemp.png",
                width: 300,
                height: 330,
              ).centered(),
              Text(
                'No orders have been placed yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ).px(8),
            ]);
          }
          return ListView.builder(
              itemCount: (snapshot.data as dynamic).docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(
                                snap: (snapshot.data! as dynamic).docs[index])))
                        .then((v) {
                      setState(() {});
                    });
                  },
                  child: Container(
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
                                .docs[index]['products'][0]['imageUrl']),
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
                                    .docs[index]['products'][0]['productName']
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
                                    "Size = ${(snapshot.data! as dynamic).docs[index]['products'][0]['size'].toString()}"
                                        .text
                                        .color(lightColor)
                                        .size(9)
                                        .make(),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: lightColor,
                                    ),
                                    "Qty = ${(snapshot.data! as dynamic).docs[index]['products'][0]['quantity'].toString()}"
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
                                    "Pending",
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ).centered(),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    '\$ ${(snapshot.data! as dynamic).docs[index]['totalAmount']}'
                                        .text
                                        .bold
                                        .size(15)
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make()
                                        .px(6),
                                    'Items: ${(snapshot.data! as dynamic).docs[index]['products'].length}'
                                        .text
                                        .size(14)
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make()
                                        .px(6),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              }).px16();
        });
  }

  Widget cancelled(TheamModal theamNotifier) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("orders")
            .where('orderStatus', isEqualTo: 'Cancelled')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data! as dynamic).docs.isEmpty) {
            return Column(children: [
              const SizedBox(
                height: 31,
              ),
              Image.asset(
                "asset/images/orderemp.png",
                width: 300,
                height: 330,
              ).centered(),
              Text(
                'No orders have been cancelled yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ).px(8),
            ]);
          }
          return ListView.builder(
              itemCount: (snapshot.data as dynamic).docs.length,
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
                              .docs[index]['products'][0]['imageUrl']),
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
                                  .docs[index]['products'][0]['productName']
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
                                  "Size = ${(snapshot.data! as dynamic).docs[index]['products'][0]['size'].toString()}"
                                      .text
                                      .color(lightColor)
                                      .size(9)
                                      .make(),
                                  Container(
                                    height: 15,
                                    width: 1,
                                    color: lightColor,
                                  ),
                                  "Qty = ${(snapshot.data! as dynamic).docs[index]['products'][0]['quantity'].toString()}"
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
                                  "Cancelled",
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black),
                                ).centered(),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  '\$ ${(snapshot.data! as dynamic).docs[index]['totalAmount']}'
                                      .text
                                      .bold
                                      .size(15)
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .make()
                                      .px(6),
                                  'Items: ${(snapshot.data! as dynamic).docs[index]['products'].length}'
                                      .text
                                      .size(14)
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .make()
                                      .px(6),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
              }).px16();
        });
  }

  Widget delivered(TheamModal theamNotifier) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("orders")
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
                  const SizedBox(
                    height: 31,
                  ),
                  Image.asset(
                    "asset/images/orderemp.png",
                    width: 300,
                    height: 300,
                  ).centered(),
                  Text(
                    'There are no completed orders at the moment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  ).px(16),
                ]);
          }

          return ListView.builder(
              itemCount: (snapshot.data as dynamic).docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(
                                snap: (snapshot.data! as dynamic).docs[index])))
                        .then((v) {
                      setState(() {});
                    });
                  },
                  child: Container(
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
                                .docs[index]['products'][0]['imageUrl']),
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
                                    .docs[index]['products'][0]['productName']
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
                                    "Size = ${(snapshot.data! as dynamic).docs[index]['products'][0]['size'].toString()}"
                                        .text
                                        .color(lightColor)
                                        .size(9)
                                        .make(),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: lightColor,
                                    ),
                                    "Qty = ${(snapshot.data! as dynamic).docs[index]['products'][0]['quantity'].toString()}"
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
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    '\$ ${(snapshot.data! as dynamic).docs[index]['totalAmount']}'
                                        .text
                                        .bold
                                        .size(15)
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make()
                                        .px(6),
                                    'Items: ${(snapshot.data! as dynamic).docs[index]['products'].length}'
                                        .text
                                        .size(14)
                                        .color(theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .make()
                                        .px(6),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              }).px16();
        });
  }
}

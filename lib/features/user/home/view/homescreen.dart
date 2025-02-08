import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/bestseller/view/bestsellerscreen.dart';
import 'package:ecommerce_app/features/user/home_detail/view/homedetailscreen.dart';
import 'package:ecommerce_app/features/user/search/view/search_screen.dart';
import 'package:ecommerce_app/features/shared/sharedclass.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // This will track the selected tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index; // Update the selected index
      });
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    "Store Location",
                    style: TextStyle(fontSize: 12, color: lightColor),
                  ),
                  "Gulshan, Karachi"
                      .text
                      .size(16)
                      .color(theamNotifier.isDark ? Colors.white : Colors.black)
                      .bold
                      .make()
                      .pOnly(top: 5),
                ],
              ),
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
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset("asset/images/search.png")),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 45,
                        child: "Looking for shoes"
                            .text
                            .color(lightColor)
                            .size(15.7)
                            .fontWeight(FontWeight.w500)
                            .make()
                            .py12()),
                  ],
                ),
              ),
            ).px(15),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 80,
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                dividerHeight: 0,
                indicator: const BoxDecoration(
                  color: Colors
                      .transparent, // No underline or box for selected tab
                ),
                tabs: [
                  _buildTab(
                      lightImage: 'asset/images/nikelogo.png',
                      darkImage: 'asset/images/nikelight.png',
                      theamNotifier: theamNotifier,
                      index: 0),
                  _buildTab(
                      lightImage: 'asset/images/pumalight.png',
                      darkImage: 'asset/images/pumadark.png',
                      theamNotifier: theamNotifier,
                      index: 1),
                  _buildTab(
                      lightImage: 'asset/images/underlight.png',
                      darkImage: 'asset/images/underdark.png',
                      theamNotifier: theamNotifier,
                      index: 2),
                  _buildTab(
                      lightImage: 'asset/images/adidaslight.png',
                      darkImage: 'asset/images/adidasdark.png',
                      theamNotifier: theamNotifier,
                      index: 3),
                  _buildTab(
                      lightImage: 'asset/images/converselight.png',
                      darkImage: 'asset/images/conversedark.png',
                      theamNotifier: theamNotifier,
                      index: 4),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent('Nike', theamNotifier),
                  _buildTabContent('Puma', theamNotifier),
                  _buildTabContent('Under Armour', theamNotifier),
                  _buildTabContent('Adidas', theamNotifier),
                  _buildTabContent('Converse', theamNotifier),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper to build each Tab widget
  Widget _buildTab(
      {required String lightImage,
      required String darkImage,
      required TheamModal theamNotifier,
      required int index}) {
    bool isSelected = _selectedIndex == index; // Check if the tab is selected

    return Tab(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: isSelected
            ? blueColor
            : (theamNotifier.isDark
                ? mainDarkColor
                : Colors.white), // Blue if selected, otherwise default
        child: isSelected
            ? Image.asset(
                darkImage,
                width: 30,
              )
            : theamNotifier.isDark
                ? Image.asset(
                    darkImage,
                    width: 30,
                  )
                : Image.asset(
                    lightImage,
                    width: 30,
                  ),
      ),
    );
  }

  // Helper to build content for each tab
  Widget _buildTabContent(String brandName, TheamModal theamNotifier) {
    dynamic snap;
    return Container(
      color: theamNotifier.isDark ? mainColor : scaffoldColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // Example content in the tab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Shoes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const BestSellerScreen()),
                    );
                  },
                  child: "See all".text.color(blueColor).bold.size(12).make()),
            ],
          ),
          const SizedBox(height: 20),
          // Add more widgets here representing products, lists, etc.
          SizedBox(
              // width: 200,
              height: 220,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("AllProducts")
                      .where('brandName', isEqualTo: brandName)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // snap = (snapshot.data! as dynamic).docs[2];
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomeDetailScreen(
                                    snap:
                                        (snapshot.data! as dynamic).docs[index],
                                    userType: "User",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 200,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: theamNotifier.isDark
                                    ? mainDarkColor
                                    : Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    height: 130,
                                    padding: const EdgeInsets.all(11),
                                    child: Image.network(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['pictureUrl'][0],
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                  "Best Seller"
                                      .text
                                      .uppercase
                                      .color(blueColor)
                                      .size(12.4)
                                      .make()
                                      .px12(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  (snapshot.data! as dynamic)
                                      .docs[index]['productName']
                                      .toString()
                                      .text
                                      .capitalize
                                      .ellipsis
                                      .bold
                                      .color(theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .size(14.9)
                                      .make()
                                      .px12(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      "\$${(snapshot.data! as dynamic).docs[index]['price']}"
                                          .text
                                          .bold
                                          .color(theamNotifier.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .size(14)
                                          .make()
                                          .px12(),
                                      GestureDetector(
                                        onTap: () {
                                          SharedClass().pushItem(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['productName'],
                                            (snapshot.data! as dynamic)
                                                .docs[index]['brandName'],
                                            (snapshot.data! as dynamic)
                                                .docs[index]['discPrice']
                                                .toString(),
                                            (snapshot.data! as dynamic)
                                                .docs[index]['pictureUrl'][0],
                                            (snapshot.data! as dynamic)
                                                .docs[index]['productId'],
                                            (snapshot.data! as dynamic)
                                                .docs[index]['size'][0],
                                          );
                                          showSnackBar(
                                              "Item added to cart!", context);
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            color: blueColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ).centered(),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  })),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ).px4(),
              "See all".text.color(blueColor).bold.size(12).make(),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeDetailScreen(
                        snap: snap,
                        userType: "User",
                      )));
            },
            child: Container(
              width: double.maxFinite,
              height: 120,
              decoration: BoxDecoration(
                color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: double.maxFinite,
                    // color: Colors.amberAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        "BEST CHOICE"
                            .text
                            .color(blueColor)
                            .size(12)
                            .bold
                            .make(),
                        "nike air jordon"
                            .text
                            .capitalize
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .bold
                            .size(19)
                            .make(),
                        "\$560.00"
                            .text
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .bold
                            .size(15)
                            .make(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ).pOnly(left: 16, right: 1),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.maxFinite,
                      child: Image.asset("asset/images/shoes2.png"),
                    ).pOnly(right: 16, left: 2, top: 14, bottom: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),

          Text(
            'Best Items',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theamNotifier.isDark ? Colors.white : Colors.black),
          ).px4(),
          const SizedBox(height: 20),
          lastSectionOfItems(theamNotifier, brandName),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget lastSectionOfItems(TheamModal theamNotifier, String brandName) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("AllProducts")
            .where('brandName', isEqualTo: brandName)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GridView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  mainAxisExtent: 230),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeDetailScreen(
                              snap: (snapshot.data! as dynamic).docs[index],
                              userType: "User",
                            )));
                  },
                  child: Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                        color:
                            theamNotifier.isDark ? mainDarkColor : Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 135,
                          decoration: BoxDecoration(
                            color: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                (snapshot.data! as dynamic).docs[index]
                                    ['pictureUrl'][0],
                                height: 120,
                                width: 130,
                              ).centered(),
                              Positioned(
                                  top: 10,
                                  left: 10,
                                  child: CircleAvatar(
                                    backgroundColor: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    child: Icon(
                                      Icons.favorite_border_rounded,
                                      size: 18,
                                      color: theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        "Best Seller"
                            .text
                            .size(12.5)
                            .uppercase
                            .color(blueColor)
                            .make()
                            .px12(),
                        const SizedBox(
                          height: 5,
                        ),
                        (snapshot.data! as dynamic)
                            .docs[index]['productName']
                            .toString()
                            .text
                            .ellipsis
                            .capitalize
                            .bold
                            .size(18)
                            .color(theamNotifier.isDark
                                ? Colors.white
                                : Colors.black)
                            .make()
                            .px12(),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "\$${(snapshot.data! as dynamic).docs[index]['price']}"
                                .text
                                .bold
                                .size(15)
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .make(),
                            Wrap(
                                children: List.generate(2, (index) {
                              return Container(
                                width: 13,
                                height: 13,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == 0
                                        ? Colors.cyan
                                        : Colors.amber),
                              );
                            })),
                          ],
                        ).px12(),
                      ],
                    ),
                  ),
                );
              }).pOnly(top: 5);
        });
  }
}

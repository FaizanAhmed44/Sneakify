import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/Review/view/review_screen.dart';
import 'package:ecommerce_app/features/user/cart/view/cartscreen.dart';
import 'package:ecommerce_app/features/user/favorite/methods/favouritemethods.dart';
import 'package:ecommerce_app/features/shared/sharedclass.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeDetailScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final String userType;
  const HomeDetailScreen({
    super.key,
    this.snap,
    required this.userType,
  });

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  int selectedSize = 40;
  int selectImageIndex = 0;
  bool isShowSaved = false;

  @override
  void initState() {
    super.initState();
    getIsSaved();
  }

  void getIsSaved() async {
    try {
      QuerySnapshot? snap;
      snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('saved')
          .where('productId', isEqualTo: widget.snap['productId'])
          .get();
      if (snap.docs.isNotEmpty) {
        if (snap.docs[0]['productId'] == widget.snap['productId']) {
          isShowSaved = true;
        }
      } else {
        isShowSaved = false;
      }
      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(e.toString(), context);
    }
  }

  final List<int> shoeSizes = [38, 39, 40, 41, 42, 43];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainDarkColor : Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: theamNotifier.isDark ? mainColor : scaffoldColor,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Men's Shoes"
                  .text
                  .color(theamNotifier.isDark ? Colors.white : Colors.black)
                  .bold
                  .make(),
              widget.userType == "Admin"
                  ? const SizedBox()
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await FavouriteMethods().saveProduct(
                                widget.snap['productId'],
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.snap['productName'],
                                widget.snap['pictureUrl'][0]);
                            setState(() {});
                            getIsSaved();
                          },
                          child: CircleAvatar(
                            backgroundColor: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white,
                            child: Icon(
                              isShowSaved
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white,
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
        body: ListView(
          // padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.25,
              padding: widget.snap['brandName'] == "Under Armour"
                  ? const EdgeInsets.only(
                      bottom: 40, top: 10, left: 10, right: 10)
                  : const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                color: theamNotifier.isDark ? mainColor : scaffoldColor,
              ),
              child: Image.network(
                widget.snap['pictureUrl'][selectImageIndex],
                fit: BoxFit.contain,
              ),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: theamNotifier.isDark ? mainColor : scaffoldColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
            "BEST SELLER"
                .text
                .color(blueColor)
                .size(screenWidth * 0.04)
                .bold
                .make()
                .px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.01),
            widget.snap['productName']
                .toString()
                .text
                .capitalize
                .bold
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .size(screenWidth * 0.06)
                .make()
                .py4()
                .px(screenWidth * 0.045),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '\$${widget.snap['price']}'
                    .text
                    .capitalize
                    .bold
                    .color(theamNotifier.isDark ? Colors.white : Colors.black)
                    .size(screenWidth * 0.05)
                    .make(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewsScreen(
                            reviewsNew: widget.snap['review'],
                            averageRating: widget.snap['averageRating']),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      '${widget.snap['averageRating']}   (${widget.snap['review'].length} reviews)'
                          .text
                          .bold
                          .color(lightColor)
                          .size(screenWidth * 0.03)
                          .make()
                    ],
                  ),
                )
              ],
            ).py4().px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.011),
            widget.snap['description']
                .toString()
                .text
                .ellipsis
                .color(lightColor)
                .maxLines(4)
                .size(screenWidth * 0.04)
                .make()
                .px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.014),
            "Gallery"
                .text
                .bold
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .size(screenWidth * 0.05)
                .make()
                .px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.017),
            Wrap(
              spacing: screenWidth * 0.03,
              children:
                  List.generate(widget.snap['pictureUrl'].length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectImageIndex = index;
                    });
                  },
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      boxShadow: selectImageIndex == index
                          ? [
                              BoxShadow(
                                color: theamNotifier.isDark
                                    ? const Color.fromARGB(255, 143, 155, 165)
                                    : const Color.fromARGB(255, 193, 193, 193)
                                        .withOpacity(0.7),
                                spreadRadius: 3,
                                blurRadius: 5,
                              ),
                            ]
                          : [],
                      color: theamNotifier.isDark ? mainColor : scaffoldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(widget.snap['pictureUrl'][index]),
                  ),
                );
              }),
            ).px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.025),
            "Size"
                .text
                .bold
                .color(theamNotifier.isDark ? Colors.white : Colors.black)
                .size(screenWidth * 0.05)
                .make()
                .px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.005),
            Wrap(
              spacing: screenWidth * 0.035,
              children: widget.snap['size'].map<Widget>((size) {
                bool isSelected = size == selectedSize;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                  child: Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? blueColor
                          : theamNotifier.isDark
                              ? mainColor
                              : scaffoldColor,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size.toString(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Disc Price"
                        .text
                        .color(lightColor)
                        .size(screenWidth * 0.04)
                        .make()
                        .py2(),
                    "\$${widget.snap['discPrice']}"
                        .text
                        .bold
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(screenWidth * 0.05)
                        .make(),
                  ],
                ),
                widget.userType == "Admin"
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          SharedClass().pushItem(
                            widget.snap['productName'],
                            widget.snap['brandName'],
                            widget.snap['discPrice'].toString(),
                            widget.snap['pictureUrl'][0],
                            widget.snap['productId'],
                            widget.snap['size'][0],
                          );
                          showSnackBar("Item added to cart!", context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.017,
                            horizontal: screenWidth * 0.09,
                          ),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: "Add To Cart"
                              .text
                              .white
                              .bold
                              .size(screenWidth * 0.040)
                              .make(),
                        ),
                      ),
              ],
            ).px(screenWidth * 0.045),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      );
    });
  }
}

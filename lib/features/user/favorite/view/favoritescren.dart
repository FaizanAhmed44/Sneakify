// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/const/colors.dart';
// import 'package:ecommerce_app/features/bestseller/view/bestsellerscreen.dart';
// import 'package:ecommerce_app/features/favorite/methods/favouritemethods.dart';
// import 'package:ecommerce_app/features/home_detail/view/homedetailscreen.dart';
// import 'package:ecommerce_app/theme/theme_modal.dart';
// import 'package:ecommerce_app/utils/snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:velocity_x/velocity_x.dart';

// class Favoritescren extends StatefulWidget {
//   const Favoritescren({super.key});

//   @override
//   State<Favoritescren> createState() => _FavoritescrenState();
// }

// class _FavoritescrenState extends State<Favoritescren> {
//   bool isShowSaved = true;
//   final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];

//   // Array to store selected sizes
//   List<String> selectedSizes = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   void toggleSizeSelection(String size) {
//     setState(() {
//       if (selectedSizes.contains(size)) {
//         selectedSizes.remove(size);
//       } else {
//         selectedSizes.add(size);
//       }
//     });
//   }

//   void getIsSaved(String productId) async {
//     try {
//       QuerySnapshot? snap;
//       snap = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('saved')
//           .where('productId', isEqualTo: productId)
//           .get();
//       if (snap.docs.isNotEmpty) {
//         if (snap.docs[0]['productId'] == productId) {
//           isShowSaved = true;
//         }
//       } else {
//         isShowSaved = false;
//       }
//       setState(() {});
//     } catch (e) {
//       // ignore: use_build_context_synchronously
//       showSnackBar(e.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
//       return Scaffold(
//         backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
//         appBar: AppBar(
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               color: theamNotifier.isDark ? mainColor : scaffoldColor,
//             ),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               "Favourite"
//                   .text
//                   .color(theamNotifier.isDark ? Colors.white : Colors.black)
//                   .bold
//                   .make(),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     theamNotifier.isDark = !theamNotifier.isDark;
//                   });
//                 },
//                 child: theamNotifier.isDark
//                     ? const Icon(Icons.light_mode)
//                     : const Icon(Icons.dark_mode),
//               ),
//             ],
//           ),
//         ),
//         body: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .collection("saved")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               if ((snapshot.data! as dynamic).docs.isEmpty) {
//                 return Column(
//                     // mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Image.asset(
//                         "asset/images/fav.png",
//                         width: 350,
//                         height: 350,
//                       ).centered(),
//                       "Your Wishlist is Empty!"
//                           .text
//                           .bold
//                           .color(theamNotifier.isDark
//                               ? Colors.white
//                               : Colors.black)
//                           .size(28)
//                           .makeCentered(),
//                       const SizedBox(
//                         height: 22,
//                       ),
//                       const Text(
//                         'Oops, your wishlist is feeling a little lonely! Add some items to keep it company.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: lightColor),
//                       ).px(22),
//                       const SizedBox(
//                         height: 29,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (context) => const BestSellerScreen()),
//                           );
//                         },
//                         child: Container(
//                           height: 48,
//                           width: double.maxFinite,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF5B9EE1),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: "Browse Product"
//                               .text
//                               .color(Colors.white)
//                               .size(16)
//                               .bold
//                               .make()
//                               .centered(),
//                         ),
//                       ).px(24),
//                     ]);
//               }

//               return GridView.builder(
//                   itemCount: (snapshot.data! as dynamic).docs.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 20,
//                       crossAxisSpacing: 15,
//                       mainAxisExtent: 230),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () async {
//                         final snap = await FirebaseFirestore.instance
//                             .collection("AllProducts")
//                             .doc((snapshot.data! as dynamic).docs[index]
//                                 ['productId'])
//                             .get();
//                         // ignore: use_build_context_synchronously
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => HomeDetailScreen(
//                                   snap: snap,
//                                 )));
//                       },
//                       child: Container(
//                         height: 300,
//                         width: 200,
//                         decoration: BoxDecoration(
//                             color: theamNotifier.isDark
//                                 ? mainDarkColor
//                                 : Colors.white,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: double.maxFinite,
//                               height: 135,
//                               decoration: BoxDecoration(
//                                 color: theamNotifier.isDark
//                                     ? mainDarkColor
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Stack(
//                                 children: [
//                                   Image.network(
//                                     (snapshot.data! as dynamic).docs[index]
//                                         ['postImage'],
//                                     height: 120,
//                                     width: 130,
//                                   ).centered(),
//                                   Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: GestureDetector(
//                                         onTap: () async {
//                                           await FavouriteMethods().saveProduct(
//                                               (snapshot.data! as dynamic)
//                                                   .docs[index]['productId'],
//                                               FirebaseAuth
//                                                   .instance.currentUser!.uid,
//                                               (snapshot.data! as dynamic)
//                                                   .docs[index]['productName'],
//                                               (snapshot.data! as dynamic)
//                                                   .docs[index]['postImage'][0]);
//                                           setState(() {});
//                                           // getIsSaved((snapshot.data! as dynamic)
//                                           //     .docs[index]['productId']);

//                                           // setState(() {});
//                                         },
//                                         child: CircleAvatar(
//                                             backgroundColor:
//                                                 theamNotifier.isDark
//                                                     ? mainColor
//                                                     : scaffoldColor,
//                                             child: const Icon(
//                                               Icons.favorite,
//                                               size: 18,
//                                               color: blueColor,
//                                             )),
//                                       ))
//                                 ],
//                               ),
//                             ),
//                             "Best Seller"
//                                 .text
//                                 .size(12.5)
//                                 .uppercase
//                                 .color(blueColor)
//                                 .make()
//                                 .px12(),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             (snapshot.data! as dynamic)
//                                 .docs[index]['productName']
//                                 .toString()
//                                 .text
//                                 .ellipsis
//                                 .capitalize
//                                 .bold
//                                 .size(18)
//                                 .color(theamNotifier.isDark
//                                     ? Colors.white
//                                     : Colors.black)
//                                 .make()
//                                 .px12(),
//                             const SizedBox(
//                               height: 7,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 "\$47.7"
//                                     .text
//                                     .bold
//                                     .size(15)
//                                     .color(theamNotifier.isDark
//                                         ? Colors.white
//                                         : Colors.black)
//                                     .make(),
//                                 Wrap(
//                                     children: List.generate(2, (index) {
//                                   return Container(
//                                     width: 13,
//                                     height: 13,
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: index == 0
//                                             ? Colors.cyan
//                                             : Colors.amber),
//                                   );
//                                 })),
//                               ],
//                             ).px12(),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).px(18).pOnly(top: 5);
//             }),
//       );
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/bestseller/view/bestsellerscreen.dart';
import 'package:ecommerce_app/features/user/favorite/methods/favouritemethods.dart';
import 'package:ecommerce_app/features/user/home_detail/view/homedetailscreen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class Favoritescren extends StatefulWidget {
  const Favoritescren({super.key});

  @override
  State<Favoritescren> createState() => _FavoritescrenState();
}

class _FavoritescrenState extends State<Favoritescren> {
  bool isShowSaved = true;
  final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];
  List<String> selectedSizes = [];

  @override
  void initState() {
    super.initState();
  }

  void toggleSizeSelection(String size) {
    setState(() {
      if (selectedSizes.contains(size)) {
        selectedSizes.remove(size);
      } else {
        selectedSizes.add(size);
      }
    });
  }

  void getIsSaved(String productId) async {
    try {
      QuerySnapshot? snap;
      snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('saved')
          .where('productId', isEqualTo: productId)
          .get();
      if (snap.docs.isNotEmpty) {
        if (snap.docs[0]['productId'] == productId) {
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

  Widget shimmerPlaceholder(TheamModal theamNotifier) {
    return Shimmer.fromColors(
      baseColor: theamNotifier.isDark
          ? mainDarkColor.withOpacity(0.2)
          : Colors.grey[300]!,
      highlightColor:
          theamNotifier.isDark ? Colors.grey[50]! : Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 135,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Container(
              height: 20,
              width: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: 40,
              color: Colors.white,
            ),
          ],
        ).px12(),
      ),
    );
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
              "Favourite"
                  .text
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("saved")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Show shimmer placeholders while data is loading
              return GridView.builder(
                itemCount: 6, // Number of shimmer placeholders
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  mainAxisExtent: 230,
                ),
                itemBuilder: (context, index) =>
                    shimmerPlaceholder(theamNotifier),
              ).px(18).pOnly(top: 5);
            }

            if ((snapshot.data! as dynamic).docs.isEmpty) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    "asset/images/fav.png",
                    width: 350,
                    height: 350,
                  ).centered(),
                  "Your Wishlist is Empty!"
                      .text
                      .bold
                      .color(theamNotifier.isDark ? Colors.white : Colors.black)
                      .size(28)
                      .makeCentered(),
                  const SizedBox(height: 22),
                  const Text(
                    'Oops, your wishlist is feeling a little lonely! Add some items to keep it company.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lightColor),
                  ).px(22),
                  const SizedBox(height: 29),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const BestSellerScreen()),
                      );
                    },
                    child: Container(
                      height: 48,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B9EE1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: "Browse Product"
                          .text
                          .color(Colors.white)
                          .size(16)
                          .bold
                          .make()
                          .centered(),
                    ),
                  ).px(24),
                ],
              );
            }

            return GridView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 15,
                mainAxisExtent: 230,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final snap = await FirebaseFirestore.instance
                        .collection("AllProducts")
                        .doc((snapshot.data! as dynamic).docs[index]
                            ['productId'])
                        .get();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeDetailScreen(
                          snap: snap,
                          userType: "User",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                                    ['postImage'],
                                height: 120,
                                width: 130,
                              ).centered(),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () async {
                                    await FavouriteMethods().saveProduct(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['productId'],
                                      FirebaseAuth.instance.currentUser!.uid,
                                      (snapshot.data! as dynamic).docs[index]
                                          ['productName'],
                                      (snapshot.data! as dynamic).docs[index]
                                          ['postImage'][0],
                                    );
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    child: const Icon(
                                      Icons.favorite,
                                      size: 18,
                                      color: blueColor,
                                    ),
                                  ),
                                ),
                              ),
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
                        const SizedBox(height: 5),
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
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "\$47.7"
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
                                    color:
                                        index == 0 ? Colors.cyan : Colors.amber,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ).px12(),
                      ],
                    ),
                  ),
                );
              },
            ).px(18).pOnly(top: 5);
          },
        ),
      );
    });
  }
}

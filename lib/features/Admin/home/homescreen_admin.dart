import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/home/edit_product_screen.dart';
import 'package:ecommerce_app/features/user/home_detail/view/homedetailscreen.dart';
import 'package:ecommerce_app/features/user/search/view/search_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomescreenAdmin extends StatefulWidget {
  const HomescreenAdmin({super.key});

  @override
  State<HomescreenAdmin> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomescreenAdmin>
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
                    height: 5,
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 15, color: lightColor),
                  ),
                  "Admin"
                      .text
                      .size(20)
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
          ).px(6),
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
    return Container(
      color: theamNotifier.isDark ? mainColor : scaffoldColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          Text(
            'Total $brandName Products',
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
                              userType: "Admin",
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
                                child: GestureDetector(
                                  onTap: () {
                                    _showEditDeleteDialog(
                                        (snapshot.data! as dynamic).docs[index],
                                        theamNotifier);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: theamNotifier.isDark
                                        ? mainColor
                                        : scaffoldColor,
                                    child: Icon(
                                      Icons.more_vert,
                                      size: 18,
                                      color: theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black,
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

  void _showEditDeleteDialog(
      QueryDocumentSnapshot product, TheamModal theamNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theamNotifier.isDark ? mainDarkColor : scaffoldColor,
          title: const Text(
            'Manage Product',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: (theamNotifier.isDark ? Colors.white : Colors.black)
                color: blueColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  // color: blueColor,
                ),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                        productData: product,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteProduct(product.id);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('AllProducts')
          .doc(productId)
          .delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting product')));
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/const/colors.dart';
// import 'package:ecommerce_app/features/user/search/view/search_screen.dart';
// import 'package:ecommerce_app/theme/theme_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // import 'edit_product_screen.dart';
// // import 'theme_modal.dart';

// class HomescreenAdmin extends StatefulWidget {
//   const HomescreenAdmin({Key? key}) : super(key: key);

//   @override
//   _HomescreenAdminState createState() => _HomescreenAdminState();
// }

// class _HomescreenAdminState extends State<HomescreenAdmin>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TheamModal>(
//       builder: (context, theamNotifier, child) {
//         return Scaffold(
//           backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
//           appBar: AppBar(
//             title: const Text('Admin Home'),
//             backgroundColor:
//                 theamNotifier.isDark ? mainDarkColor : scaffoldColor,
//           ),
//           body: TabBarView(
//             controller: _tabController,
//             children: List.generate(
//               3,
//               (index) => _buildTabContent(
//                   ['Nike', 'Puma', 'Adidas'][index], theamNotifier),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTabContent(String brandName, TheamModal theamNotifier) {
//     return FutureBuilder(
//       future: FirebaseFirestore.instance
//           .collection("AllProducts")
//           .where('brandName', isEqualTo: brandName)
//           .get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return GridView.builder(
//           itemCount: (snapshot.data as QuerySnapshot).docs.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemBuilder: (context, index) {
//             var product = (snapshot.data as QuerySnapshot).docs[index];
//             return _buildProductCard(theamNotifier, product);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildProductCard(
//       TheamModal theamNotifier, QueryDocumentSnapshot product) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.network(
//                     product['productImage'],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: () {
//                       _showEditDeleteDialog(product);
//                     },
//                     child: const Icon(Icons.more_vert),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(product['productName'],
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text("\$${product['price']}",
//                       style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditDeleteDialog(QueryDocumentSnapshot product) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Manage Product'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => SearchScreen(),
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _deleteProduct(product.id);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _deleteProduct(String productId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('AllProducts')
//           .doc(productId)
//           .delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Product deleted successfully')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error deleting product')));
//     }
//   }
// }

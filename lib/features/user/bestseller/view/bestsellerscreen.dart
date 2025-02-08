import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/home_detail/view/homedetailscreen.dart';
import 'package:ecommerce_app/features/user/search/view/search_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({super.key});

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  // Filter selections
  String? selectedGender;
  double minPrice = 100;
  double maxPrice = 1050;
  bool isFilter = false;
  double? selectedMinPrice;
  String? selectedGenderFilter;
  double? selectedMaxPrice;

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
                "Best Sellers"
                    .text
                    .size(18)
                    .color(theamNotifier.isDark ? Colors.white : Colors.black)
                    .bold
                    .make()
                    .px4(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => StatefulBuilder(
                            builder: (context, setModalState) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 4,
                                      width: 75,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Container()),
                                        Text(
                                          "Filters",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theamNotifier.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ).pOnly(left: 50),
                                        Expanded(child: Container()),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isFilter = false;
                                              selectedMaxPrice = null;
                                              selectedMinPrice = null;
                                              Navigator.pop(context);
                                              minPrice = 100;
                                              maxPrice = 1050;
                                              selectedGender = null;
                                            });
                                          },
                                          child: const Text(
                                            "RESET",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: lightColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Gender",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: theamNotifier.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: ["Men", "Women", "Unisex"]
                                              .map((gender) {
                                            return GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedGender = gender;
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                height: 45,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      selectedGender == gender
                                                          ? blueColor
                                                          : theamNotifier.isDark
                                                              ? filterColor
                                                              : lineColor,
                                                  borderRadius:
                                                      BorderRadius.circular(27),
                                                ),
                                                child: Text(
                                                  gender,
                                                  style: TextStyle(
                                                    color: selectedGender ==
                                                            gender
                                                        ? Colors.white
                                                        : theamNotifier.isDark
                                                            ? lightColor
                                                            : lightColor,
                                                  ),
                                                ).centered(),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: theamNotifier.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        RangeSlider(
                                          values:
                                              RangeValues(minPrice, maxPrice),
                                          min: 100,
                                          max: 1050,
                                          activeColor: blueColor,
                                          inactiveColor: theamNotifier.isDark
                                              ? filterColor
                                              : lineColor,
                                          divisions: 80,
                                          labels: RangeLabels(
                                              "\$${minPrice.round()}",
                                              "\$${maxPrice.round()}"),
                                          onChanged: (values) {
                                            setModalState(() {
                                              minPrice = values.start;
                                              maxPrice = values.end;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, {
                                          'gender': selectedGender,
                                          'minPrice': minPrice,
                                          'maxPrice': maxPrice,
                                        });
                                      },
                                      child: Container(
                                        height: 58,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5B9EE1),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: "Apply"
                                            .text
                                            .color(Colors.white)
                                            .size(18)
                                            .bold
                                            .make()
                                            .centered(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ).px16();
                            },
                          ),
                        ).then((filters) {
                          if (filters != null) {
                            if (filters['gender'] != null) {
                              selectedGenderFilter = filters['gender'];
                              selectedMaxPrice = filters['maxPrice'];
                              selectedMinPrice = filters['minPrice'];
                            } else {
                              selectedMaxPrice = filters['maxPrice'];
                              selectedMinPrice = filters['minPrice'];
                            }
                            isFilter = true;
                            setState(() {});
                            // Use the selected filters here
                            // print(
                            //     "Selected Filters: ${filters['minPrice']} ${filters['maxPrice']} $isFilter ${filters['gender']}");
                          }
                        });
//
                      },
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: theamNotifier.isDark
                            ? Image.asset("asset/images/filterdark.png")
                            : Image.asset("asset/images/filterlight.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                      },
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: theamNotifier.isDark
                            ? Image.asset("asset/images/searchdark.png")
                            : Image.asset("asset/images/searchlight.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: FutureBuilder(
              future: isFilter
                  ? FirebaseFirestore.instance
                      .collection("AllProducts")
                      .where('gender', isEqualTo: selectedGenderFilter)
                      .where('price', isGreaterThan: selectedMinPrice)
                      .where('price', isLessThan: selectedMaxPrice)
                      .orderBy('price')
                      .get()
                  : FirebaseFirestore.instance.collection("AllProducts").get(),
              builder: (context, snapshot) {
                // if (!snapshot.hasData) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                if (!snapshot.hasData) {
                  return GridView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 15,
                      mainAxisExtent: 230,
                    ),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: theamNotifier.isDark
                            ? mainDarkColor.withOpacity(0.2)
                            : Colors.grey[300]!,
                        highlightColor: theamNotifier.isDark
                            ? Colors.grey[50]!
                            : Colors.grey[100]!,
                        child: Container(
                          height: 300,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    },
                  ).px(18).pOnly(top: 5);
                }
                return GridView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  userType: "User")));
                        },
                        child: Container(
                          height: 300,
                          width: 200,
                          decoration: BoxDecoration(
                              color: theamNotifier.isDark
                                  ? mainDarkColor
                                  : Colors.white,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                    }).px(18).pOnly(top: 5);
              }));
    });
  }
}

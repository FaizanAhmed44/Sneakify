import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ReviewsScreen extends StatefulWidget {
  final List<dynamic> reviewsNew;
  final double averageRating;
  const ReviewsScreen(
      {super.key, required this.reviewsNew, required this.averageRating});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int selectedFilter = 0;
  int daysAgo = 0;

  void calculateDaysAgo(int index) {
    Timestamp orderTimestamp = widget.reviewsNew[index]['reviewDate'];
    DateTime orderDate = orderTimestamp.toDate();
    DateTime now = DateTime.now();
    daysAgo = now.difference(orderDate).inDays;
    // print("The order was placed $daysAgo days ago.");
  }

  // Sample data for reviews
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Darlene Robertson",
      "rating": 5,
      "text": "The item is very good, my son likes it very much!",
      "likes": 729,
      "date": "6 days ago"
    },
    {
      "name": "Jane Cooper",
      "rating": 4,
      "text": "The seller is very fast in sending the packet!",
      "likes": 625,
      "date": "6 days ago"
    },
    {
      "name": "Jenny Wilson",
      "rating": 3,
      "text": "The vase is really good! I highly recommend it!",
      "likes": 578,
      "date": "6 days ago"
    },
    {
      "name": "Marvin McKinney",
      "rating": 5,
      "text": "The item is very good, my son likes it very much!",
      "likes": 347,
      "date": "6 weeks ago"
    },
    {
      "name": "Theresa Webb",
      "rating": 4,
      "text": "The seller is very fast in sending the packet!",
      "likes": 292,
      "date": "3 weeks ago"
    },
  ];

  List<Map<String, dynamic>> get filteredReviews {
    if (selectedFilter == 0) return reviews;
    return reviews
        .where((review) => review["rating"] == selectedFilter)
        .toList();
  }

  List<dynamic> get filteredReviews1 {
    if (selectedFilter == 0) return widget.reviewsNew;
    return widget.reviewsNew
        .where((review) => review["rating"] == selectedFilter)
        .toList();
  }

  void selectFilter(int rating) {
    setState(() {
      selectedFilter = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: Text(
            "${widget.averageRating} (${widget.reviewsNew.length} reviews)",
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          // leading: Icon(Icons.arrow_back),
        ),
        body: Column(
          children: [
            // Rating Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(
                        "All",
                        style: TextStyle(
                            color: selectedFilter == 0
                                ? theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black
                                : Colors.white),
                      ),
                      selected: selectedFilter == 0,
                      onSelected: (_) => selectFilter(0),
                      backgroundColor:
                          selectedFilter == 0 ? lightColor : mainDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Set the desired radius here
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    for (int rating = 5; rating >= 2; rating--)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: ChoiceChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the desired radius here
                          ),
                          backgroundColor: selectedFilter == rating
                              ? lightColor
                              : mainDarkColor,
                          label: Row(
                            children: [
                              Icon(Icons.star,
                                  size: 16,
                                  color: selectedFilter == rating
                                      ? theamNotifier.isDark
                                          ? Colors.white
                                          : Colors.black
                                      : Colors.white),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "$rating",
                                style: TextStyle(
                                    color: selectedFilter == rating
                                        ? theamNotifier.isDark
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.white),
                              )
                            ],
                          ),
                          selected: selectedFilter == rating,
                          onSelected: (_) => selectFilter(rating),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Reviews List
            Expanded(
              child: ListView.builder(
                itemCount: filteredReviews1.length,
                itemBuilder: (context, index) {
                  calculateDaysAgo(index);
                  return reviewCard(
                      filteredReviews[index], theamNotifier, index);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget reviewCard(Map<String, dynamic> review, theamNotifier, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: theamNotifier.isDark ? mainDarkColor : Colors.white,
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundImage:
                          widget.reviewsNew[index]['profPictureUrl'] == ""
                              ? const AssetImage("asset/images/profile.png")
                              : NetworkImage(
                                  widget.reviewsNew[index]['profPictureUrl'])),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.reviewsNew[index]["userName"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black)),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: List.generate(
                          widget.reviewsNew[index]["rating"].toInt(),
                          (starIndex) => const Icon(Icons.star,
                              size: 16, color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.reviewsNew[index]["review"],
                style: const TextStyle(fontSize: 14.0, color: lightColor),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Icon(Icons.favorite, size: 16, color: Colors.pink[300]),
                  const SizedBox(width: 7.0),
                  Text(
                    "${review["likes"]}",
                    style: TextStyle(
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    '$daysAgo days ago',
                    style: const TextStyle(color: lightColor),
                  ).pOnly(bottom: 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget reviewCard(Map<String, dynamic> review, theamNotifier) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: theamNotifier.isDark ? mainDarkColor : Colors.white,
  //           borderRadius: BorderRadius.circular(25)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(17.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const CircleAvatar(
  //                   backgroundImage: AssetImage(
  //                       "asset/images/profile.png"), // Replace with dynamic user image if available
  //                 ),
  //                 const SizedBox(width: 16.0),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(review["name"],
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: theamNotifier.isDark
  //                                 ? Colors.white
  //                                 : Colors.black)),
  //                     const SizedBox(
  //                       height: 6,
  //                     ),
  //                     Row(
  //                       children: List.generate(
  //                         review["rating"],
  //                         (starIndex) => const Icon(Icons.star,
  //                             size: 16, color: Colors.amber),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 15.0),
  //             Text(
  //               review["text"],
  //               style: const TextStyle(fontSize: 14.0, color: lightColor),
  //             ),
  //             const SizedBox(height: 12.0),
  //             Row(
  //               children: [
  //                 Icon(Icons.favorite, size: 16, color: Colors.pink[300]),
  //                 const SizedBox(width: 7.0),
  //                 Text(
  //                   "${review["likes"]}",
  //                   style: TextStyle(
  //                       color:
  //                           theamNotifier.isDark ? Colors.white : Colors.black),
  //                 ),
  //                 const Spacer(),
  //                 Text(
  //                   review["date"],
  //                   style: const TextStyle(color: lightColor),
  //                 ).pOnly(bottom: 3),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

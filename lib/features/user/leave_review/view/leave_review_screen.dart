// ignore_for_file: public_member_api_docs, sort_constructors_firs
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/user/leave_review/logic/reviewmethods.dart';
import 'package:ecommerce_app/features/login/logic/authmethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';

class LeaveReviewBottomSheet extends StatefulWidget {
  final Map<String, dynamic> products; // Each product has its own details

  const LeaveReviewBottomSheet({
    super.key,
    required this.products,
  });

  @override
  State<LeaveReviewBottomSheet> createState() => _LeaveReviewBottomSheetState();
}

class _LeaveReviewBottomSheetState extends State<LeaveReviewBottomSheet> {
  final TextEditingController reviewController = TextEditingController();
  double ratingRev = 0.0;
  bool isLoading = false;
  String? errorText;
  DocumentSnapshot? user;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    // userModel =
    DocumentSnapshot snap = await AuthMethods().getUserDetail();
    user = snap;
    setState(() {});
  }

  // Validator function
  String? validate(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Function to trigger validation
  bool validateField() {
    setState(() {
      errorText = validate(reviewController.text);
    });
    if (errorText == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theamNotifier.isDark ? mainColor : scaffoldColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber line
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Leave a Review",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: theamNotifier.isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: lightColor,
                thickness: 0.7,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Container(
                      width: 95,
                      height: 100,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: theamNotifier.isDark ? mainColor : scaffoldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(widget.products['imageUrl']),
                    ),
                    const SizedBox(width: 17),
                    // Product Details
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.products['productName'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Qty = ${widget.products['quantity']}",
                            style: const TextStyle(
                                fontSize: 14, color: lightColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 9),
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Completed",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white),
                                ),
                              ),
                              Text(
                                "\$${widget.products['quantity'] * double.parse(widget.products['price'])}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: lightColor,
                thickness: 0.4,
              ),
              const SizedBox(height: 20),
              Text(
                "How is your order?",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: theamNotifier.isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please give your rating & also your review...",
                style: TextStyle(fontSize: 14, color: lightColor),
              ),
              const SizedBox(height: 10),

              // Rating Section
              Center(
                child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    // allowHalfRating: true,
                    itemSize: 35,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 5.5),
                    itemBuilder: (context, _) {
                      return const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 255, 213, 59),
                      );
                    },
                    onRatingUpdate: (rating) {
                      // print(rating);
                      setState(() {
                        ratingRev = rating;
                      });
                    }),
              ),
              // Review Text Input
              const SizedBox(height: 20),
              TextFormField(
                controller: reviewController,
                // initialValue: "Very good product & fast delivery!",
                style: const TextStyle(color: lightColor, fontSize: 15),
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Type here!",
                  errorText: errorText,
                  fillColor:
                      theamNotifier.isDark ? mainDarkColor : Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: lightColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: lightColor),
                  ),
                  suffixIcon: const Icon(
                    Icons.photo_camera_back_outlined,
                    color: Colors.grey,
                  ),
                ),
              ).px4(),
              const SizedBox(height: 20),
              const Divider(
                color: lightColor,
                thickness: 0.4,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(146, 161, 172, 182),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: "Cancel"
                          .text
                          .color(theamNotifier.isDark
                              ? Colors.white
                              : const Color.fromARGB(158, 0, 0, 0))
                          .size(16)
                          .bold
                          .make()
                          .centered(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool isTrue = validateField();
                      if (isTrue) {
                        setState(() {
                          isLoading = true;
                        });

                        await ReviewMethods().addRatingAndReview(
                            productId: widget.products['productId'],
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            userName: (user!.data() as dynamic)['userName']
                                .toString(),
                            profPictureUrl:
                                (user!.data() as dynamic)['profileUrl']
                                    .toString(),
                            rating: ratingRev,
                            review: reviewController.text);

                        setState(() {
                          isLoading = false;
                          reviewController.clear();
                          Navigator.pop(context);
                        });
                      } else {}
                    },
                    child: Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            ).centered()
                          : "Submit"
                              .text
                              .color(Colors.white)
                              .size(16)
                              .bold
                              .make()
                              .centered(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

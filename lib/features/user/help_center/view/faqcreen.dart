import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List faqQuestion = [
    "How do I search for a book?",
    "How do I borrow a book?",
    "How do I reset my password?",
    "How do I contact support?",
    "How can I update my profile information?",
    "Can I read books on multiple devices?",
    "How do I stay updated on new book releases?",
    "What should I do if I forget my password?",
    "Is there a limit to how many books I can borrow at once?",
    "Can I read books offline?"
  ];
  List faqAnswer = [
    "You can search for a book by tapping on the search icon at the top of the home page. Enter the book title, author, or keywords to find relevant results.",
    "To borrow a book, select it from the search results or the main library. If the book is available, tap the “Borrow” button, and it will be added to your account.",
    "To reset your password, go to the login page and click on “Forgot Password.” Enter your registered email address to receive password reset instructions.",
    "You can reach out to our support team via the “Contact Us” option in the Help & Support section of the app.",
    "To update your profile information, navigate to the Settings page, then click on “Profile” and update your name, email, or profile picture.",
    "Yes, you can access your account and read books on multiple devices. Ensure you are logged in with the same account credentials.",
    "To stay informed about new book releases, enable notifications in the Settings. You can also check the “New Arrivals” section in the app regularly.",
    "If you forget your password, go to the login page and click on “Forgot Password.” Follow the instructions sent to your registered email to reset your password.",
    "Yes, the app has a borrowing limit. You can borrow up to 3 number of books at a time. Check the borrowing policy in the app for more details.",
    "Yes, once you download a book, you can read it offline anytime without an internet connection."
  ];
  bool isShow = false;
  List isShowQuestion = List.filled(10, false);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return ListView(children: [
        Container(
          width: double.maxFinite,
          height: 90,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 25, 109, 179)],
            ),
          ),
          child: "How can we help you ?"
              .text
              .bold
              .color(Colors.white)
              .size(27)
              .make()
              .centered(),
        ),
        Stack(
          children: [
            Container(
              width: double.maxFinite,
              height: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 25, 109, 179)],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 32,
              decoration: BoxDecoration(
                  color: theamNotifier.isDark ? mainColor : scaffoldColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
            ),
          ],
        ),
        ListView.builder(
            itemCount: faqQuestion.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isShowQuestion[index] = !isShowQuestion[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isShowQuestion[index]
                          ? theamNotifier.isDark
                              ? mainDarkColor
                              : const Color.fromARGB(255, 230, 232, 233)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(16),
                  margin:
                      EdgeInsets.only(bottom: isShowQuestion[index] ? 20 : 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: faqQuestion[index]
                                .toString()
                                .text
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .bold
                                .size(16)
                                .make(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          isShowQuestion[index]
                              ? const Icon(Icons.arrow_drop_up)
                              : const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      isShowQuestion[index]
                          ? faqAnswer[index]
                              .toString()
                              .text
                              .color(lightColor)
                              .size(15)
                              .make()
                          : Container(),
                    ],
                  ),
                ).px16(),
              );
            }),
      ]);
    });
  }
}

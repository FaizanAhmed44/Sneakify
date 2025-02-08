import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/user/help_center/view/faqcreen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> data = [
    {'image': "asset/images/whats.png", 'label': "Whatsapp"},
    {'image': "asset/images/webs.png", 'label': "Website"},
    {'image': "asset/images/insta.png", 'label': "Instagram"},
    {'image': "asset/images/fb.png", 'label': "Facebook"},
  ];

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
              "Help Center"
                  .text
                  .size(19.5)
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
              Tab(
                child: Text(
                  "FAQ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Tab(
                child: Text(
                  "Contact us",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
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
    return const FaqScreen();
  }

  Widget completed(TheamModal theamNotifier) {
    return ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
              width: double.maxFinite,
              margin: index == 0
                  ? const EdgeInsets.only(top: 25)
                  : const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    data[index]['image']!,
                    width: index == 0 ? 29 : 25,
                    height: 25,
                  ),
                  SizedBox(
                    width: index == 0 ? 17 : 20,
                  ),
                  data[index]['label']
                      .toString()
                      .text
                      .size(16)
                      // .bold
                      .color(theamNotifier.isDark ? Colors.white : Colors.black)
                      .make()
                ],
              ));
        }).px16();
  }
}

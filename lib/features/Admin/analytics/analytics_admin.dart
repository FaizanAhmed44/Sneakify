import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int totalOrders = 0;
  int totalProducts = 0;
  int pendingOrders = 0;
  int cancelledOrders = 0;
  int deliveredOrders = 0;
  double totalEarnings = 0;
  Map<String, double> categorySales = {};

  Map<int, double> weeklySales = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      // Reference to Firestore collection
      final ordersSnapshot =
          await FirebaseFirestore.instance.collection("orders").get();

      int tempPendingOrders = 0;
      int tempDeliveredOrders = 0;
      int tempCancelledOrders = 0;
      double tempTotalEarnings = 0;
      int tempTotalProducts = 0;

      Map<String, double> tempCategorySales = {};
      tempCategorySales["Nike"] = 0;
      tempCategorySales["Adidas"] = 0;
      tempCategorySales["Puma"] = 0;
      tempCategorySales["Converse"] = 0;
      tempCategorySales["Under Armour"] = 0;
      Map<int, double> tempWeeklySales = {};
      tempWeeklySales[1] = 0;
      tempWeeklySales[2] = 0;
      tempWeeklySales[3] = 0;
      tempWeeklySales[4] = 0;
      tempWeeklySales[5] = 0;
      tempWeeklySales[6] = 0;
      tempWeeklySales[7] = 0;

      for (var order in ordersSnapshot.docs) {
        final orderData = order.data();

        // Check order status
        String orderStatus = orderData['orderStatus'] ?? '';
        if (orderStatus == 'Pending' || orderStatus == "Completed") {
          tempPendingOrders++;
        } else if (orderStatus == 'Delivered') {
          tempDeliveredOrders++;
        } else {
          tempCancelledOrders++;
        }

        // Calculate total earnings
        double totalAmount =
            double.tryParse(orderData['totalAmount'].toString()) ?? 0;
        tempTotalEarnings += (totalAmount - orderData['shippingFee']);

        // Count products in each order
        List<dynamic> products = orderData['products'] ?? [];
        tempTotalProducts += products.length;

        // Track category-wise sales
        for (var product in products) {
          String brandName = product['brandName'];
          // print(brandName);
          if (brandName == "Nike") {
            double price = double.parse(product['price'].toString());
            tempCategorySales[brandName] =
                (tempCategorySales[brandName] ?? 0) + price;
          } else if (brandName == "Adidas") {
            double price = double.parse(product['price'].toString());
            tempCategorySales[brandName] =
                (tempCategorySales[brandName] ?? 0) + price;
          } else if (brandName == "Puma") {
            double price = double.parse(product['price'].toString());
            tempCategorySales[brandName] =
                (tempCategorySales[brandName] ?? 0) + price;
          } else if (brandName == "Converse") {
            double price = double.parse(product['price'].toString());
            tempCategorySales[brandName] =
                (tempCategorySales[brandName] ?? 0) + price;
          } else if (brandName == "Under Armour") {
            double price = double.parse(product['price'].toString());
            tempCategorySales[brandName] =
                (tempCategorySales[brandName] ?? 0) + price;
          } else {}
        }

        // Generate weekly sales (simulate weekday)
        int weekDay =
            DateTime.parse(orderData['orderDate']).weekday; // 1=Mon, 7=Sun
        tempWeeklySales[weekDay] = (tempWeeklySales[weekDay] ?? 0) +
            totalAmount -
            orderData['shippingFee'];
      }

      setState(() {
        totalOrders = ordersSnapshot.size;
        totalProducts = tempTotalProducts;
        pendingOrders = tempPendingOrders;
        cancelledOrders = tempCancelledOrders;
        deliveredOrders = tempDeliveredOrders;
        totalEarnings = tempTotalEarnings;
        categorySales = tempCategorySales;
        // ignore: avoid_print
        print(tempWeeklySales);
        weeklySales = tempWeeklySales;
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Insights & Analytics"
              .text
              .size(20)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make()
              .px4(),
        ),
        body: isLoading
            ? const CircularProgressIndicator().centered()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Order Overview", theamNotifier),
                      const SizedBox(height: 20),
                      _buildOrderDetails(
                          theamNotifier,
                          totalOrders,
                          pendingOrders,
                          deliveredOrders,
                          totalProducts,
                          totalEarnings),
                      const SizedBox(height: 20),
                      _buildSectionTitle(
                          "Category Wise Earnings", theamNotifier),
                      const SizedBox(height: 20),
                      _buildBarChart(theamNotifier),
                      const SizedBox(height: 20),
                      _buildSectionTitle(
                          "Order Status Distribution", theamNotifier),
                      const SizedBox(height: 20),
                      _buildPieChart(theamNotifier),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Weekly Sales Trend", theamNotifier),
                      const SizedBox(height: 20),
                      _buildLineChart(theamNotifier),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  // Section Title
  Widget _buildSectionTitle(String title, TheamModal theamNotifier) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: theamNotifier.isDark ? Colors.white : Colors.black),
    );
  }

  // Order Details Section
  Widget _buildOrderDetails(
      TheamModal theamNotifier,
      int totalOrders,
      int pendingOrders,
      int deliveredOrders,
      int totalProducts,
      double totalEarnings) {
    return Container(
      decoration: _cardDecoration(theamNotifier),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailRow(
              "Total Orders", totalOrders.toString(), theamNotifier, false),
          _buildDetailRow(
              "Total Products", totalProducts.toString(), theamNotifier, false),
          _buildDetailRow(
              "Pending Orders", pendingOrders.toString(), theamNotifier, false),
          _buildDetailRow("Delivered Orders", deliveredOrders.toString(),
              theamNotifier, false),
          _buildDetailRow("Cancelled Orders", cancelledOrders.toString(),
              theamNotifier, false),
          _buildDetailRow("Total Earnings",
              "\$${totalEarnings.toDoubleStringAsFixed()}", theamNotifier, true,
              color: Colors.green),
        ],
      ),
    );
  }

// Line Chart Widget
  Widget _buildLineChart(TheamModal theamNotifier) {
    return Container(
      decoration: _cardDecoration(theamNotifier),
      height: 250,
      padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15, right: 15),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true, // Remove vertical grid lines
            horizontalInterval: 5000,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: lightColor,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                  return Text(
                    value.toInt() < labels.length
                        ? labels[value.toInt()]
                        : '', // Show each day only once
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  );
                },
                interval: 1, // Display X-axis values at intervals
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return Text(
                    "${(value ~/ 1000)}K", // Format "1000" -> "1K"
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            theamNotifier.isDark ? Colors.white : Colors.black),
                  );
                },
                interval: 5000,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: [
                FlSpot(0, weeklySales[1]!),
                FlSpot(1, weeklySales[2]!),
                FlSpot(2, weeklySales[3]!),
                FlSpot(3, weeklySales[4]!),
                FlSpot(4, weeklySales[5]!),
                FlSpot(5, weeklySales[6]!),
                FlSpot(6, weeklySales[7]!),
              ],
              barWidth: 3,
              color: blueColor,
              // colors: [Colors.blue],
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: true), // Display dots on points
            ),
          ],
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 25000,
        ),
      ),
    );
  }

// Bar Chart Widget
  Widget _buildBarChart(TheamModal theamNotifier) {
    return Container(
      decoration: _cardDecoration(theamNotifier),
      height: 250,
      padding: const EdgeInsets.only(right: 10, left: 18, top: 25, bottom: 25),
      child: BarChart(
        BarChartData(
          barGroups: _buildBarGroups(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = [
                    "Nike",
                    "Puma",
                    "Armour",
                    "Adidas",
                    "Converse",
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[value.toInt()],
                      style: TextStyle(
                        fontSize: 11,
                        color: theamNotifier.isDark
                            ? Colors.white
                            : Colors.black, // Make X-axis labels white
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 11,
                      color: theamNotifier.isDark ? Colors.white : Colors.black,
                    ),
                  );
                },
                interval:
                    2000, // Adjust interval to control the density of labels
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true), // Hide grid lines
          borderData: FlBorderData(show: false), // Remove borders
        ),
      ),
    );
  }

  // Pie Chart
  Widget _buildPieChart(TheamModal theamNotifier) {
    return Container(
      decoration: _cardDecoration(theamNotifier),
      height: 250,
      padding: const EdgeInsets.only(top: 35, bottom: 35, left: 15, right: 15),
      child: PieChart(
        PieChartData(
          sections: _buildPieChartSections(),
          centerSpaceRadius: 60,
          sectionsSpace: 4,
        ),
      ),
    );
  }

  // Order Detail Row
  Widget _buildDetailRow(
      String title, String value, TheamModal theamNotifer, bool isTrue,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  color: theamNotifer.isDark ? Colors.white : Colors.black)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isTrue
                      ? color
                      : theamNotifer.isDark
                          ? lightColor
                          : lightColor)),
        ],
      ),
    );
  }

  // Card Decoration
  BoxDecoration _cardDecoration(TheamModal theamNotifier) {
    return BoxDecoration(
      color: theamNotifier.isDark ? mainDarkColor : Colors.white,
      // boxShadow: [
      //   // BoxShadow(
      //   //   color: Colors.grey.withOpacity(0.3),
      //   //   blurRadius: 10,
      //   //   spreadRadius: 1,
      //   //   offset: const Offset(2, 5),
      //   // ),
      // ],
      borderRadius: BorderRadius.circular(12),
    );
  }

  // Bar Chart Data
  List<BarChartGroupData> _buildBarGroups() {
    return [
      _singleBar(
          0, double.parse(categorySales["Nike"]!.toDoubleStringAsFixed())),
      _singleBar(1, categorySales["Puma"]! + 1),
      _singleBar(2, categorySales["Under Armour"]! + 1),
      _singleBar(3, categorySales["Adidas"]! + 1),
      _singleBar(4, categorySales["Converse"]! + 1),
    ];
  }

  BarChartGroupData _singleBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: RadialGradient(colors: [
            Colors.blue.withOpacity(0.2),
            blueColor.withOpacity(0.7)
          ], radius: 1),
          // color: blueColor,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Pie Chart Data
  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
          value: pendingOrders.toDouble(),
          title: 'Pending',
          titleStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          color: const Color.fromARGB(255, 243, 158, 30),
          radius: 60),
      PieChartSectionData(
        value: deliveredOrders.toDouble(),
        title: 'Delivered',
        color: const Color.fromARGB(255, 95, 202, 99),
        radius: 60,
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: cancelledOrders.toDouble(),
        title: 'Cancelled',
        color: const Color.fromARGB(255, 240, 88, 77),
        radius: 60,
        titleStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    ];
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/const/colors.dart';
// import 'package:ecommerce_app/theme/theme_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:velocity_x/velocity_x.dart';

// class AnalyticsPage extends StatefulWidget {
//   const AnalyticsPage({super.key});

//   @override
//   State<AnalyticsPage> createState() => _AnalyticsPageState();
// }

// class _AnalyticsPageState extends State<AnalyticsPage> {
//   // Data variables
//   int totalOrders = 0;
//   int totalProducts = 0;
//   int pendingOrders = 0;
//   int deliveredOrders = 0;
//   double totalEarnings = 0;
//   Map<String, double> categorySales = {};
//   Map<int, double> weeklySales = {};

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromFirebase();
//   }

//   Future<void> fetchDataFromFirebase() async {
//     try {
//       // Reference to Firestore collection
//       final ordersSnapshot =
//           await FirebaseFirestore.instance.collection("orders").get();

//       int tempPendingOrders = 0;
//       int tempDeliveredOrders = 0;
//       double tempTotalEarnings = 0;
//       int tempTotalProducts = 0;

//       Map<String, double> tempCategorySales = {};
//       Map<int, double> tempWeeklySales = {};

//       for (var order in ordersSnapshot.docs) {
//         final orderData = order.data();

//         // Check order status
//         String orderStatus = orderData['orderStatus'] ?? '';
//         if (orderStatus == 'Pending') {
//           tempPendingOrders++;
//         } else if (orderStatus == 'Completed') {
//           tempDeliveredOrders++;
//         }

//         // Calculate total earnings
//         double totalAmount =
//             double.tryParse(orderData['totalAmount'].toString()) ?? 0;
//         tempTotalEarnings += totalAmount;

//         // Count products in each order
//         List<dynamic> products = orderData['products'] ?? [];
//         tempTotalProducts += products.length;

//         // Track category-wise sales
//         for (var product in products) {
//           String productName = product['productName'] ?? 'Unknown';
//           double price = double.tryParse(product['price'].toString()) ?? 0;
//           tempCategorySales[productName] =
//               (tempCategorySales[productName] ?? 0) + price;
//         }

//         // Generate weekly sales (simulate weekday)
//         int weekDay =
//             DateTime.parse(orderData['orderDate']).weekday; // 1=Mon, 7=Sun
//         tempWeeklySales[weekDay] =
//             (tempWeeklySales[weekDay] ?? 0) + totalAmount;
//       }

//       setState(() {
//         totalOrders = ordersSnapshot.size;
//         totalProducts = tempTotalProducts;
//         pendingOrders = tempPendingOrders;
//         deliveredOrders = tempDeliveredOrders;
//         totalEarnings = tempTotalEarnings;
//         categorySales = tempCategorySales;
//         weeklySales = tempWeeklySales;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
//       return Scaffold(
//         backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
//         appBar: AppBar(
//           backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
//           title: "Insights & Analytics"
//               .text
//               .size(20)
//               .bold
//               .color(theamNotifier.isDark ? Colors.white : Colors.black)
//               .make()
//               .px4(),
//         ),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Order Overview", theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildOrderDetails(theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildSectionTitle(
//                           "Category Wise Earnings", theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildBarChart(theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildSectionTitle(
//                           "Order Status Distribution", theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildPieChart(theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildSectionTitle("Weekly Sales Trend", theamNotifier),
//                       const SizedBox(height: 20),
//                       _buildLineChart(theamNotifier),
//                     ],
//                   ),
//                 ),
//               ),
//       );
//     });
//   }

//   Widget _buildOrderDetails(TheamModal theamNotifier) {
//     return Container(
//       decoration: _cardDecoration(theamNotifier),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildDetailRow(
//               "Total Orders", totalOrders.toString(), theamNotifier, false),
//           _buildDetailRow(
//               "Total Products", totalProducts.toString(), theamNotifier, false),
//           _buildDetailRow(
//               "Pending Orders", pendingOrders.toString(), theamNotifier, false),
//           _buildDetailRow("Delivered Orders", deliveredOrders.toString(),
//               theamNotifier, false),
//           _buildDetailRow("Total Earnings",
//               "\$${totalEarnings.toStringAsFixed(2)}", theamNotifier, true,
//               color: Colors.green),
//         ],
//       ),
//     );
//   }

//   List<BarChartGroupData> _buildBarGroups() {
//     return categorySales.entries
//         .map((entry) => _singleBar(
//             categorySales.keys.toList().indexOf(entry.key),
//             entry.value.roundToDouble()))
//         .toList();
//   }

//   Widget _buildLineChart(TheamModal theamNotifier) {
//     return super._buildLineChart(theamNotifier);
//   }

//   List<PieChartSectionData> _buildPieChartSections() {
//     return [
//       PieChartSectionData(
//         value: pendingOrders.toDouble(),
//         title: 'Pending',
//         color: Colors.orange,
//         radius: 60,
//         titleStyle:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//       PieChartSectionData(
//         value: deliveredOrders.toDouble(),
//         title: 'Delivered',
//         color: Colors.green,
//         radius: 60,
//         titleStyle:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//       PieChartSectionData(
//         value: (totalOrders - (pendingOrders + deliveredOrders)).toDouble(),
//         title: 'Other',
//         color: Colors.red,
//         radius: 60,
//         titleStyle:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     ];
//   }
// }

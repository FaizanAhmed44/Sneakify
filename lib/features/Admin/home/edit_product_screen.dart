import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProductScreen extends StatefulWidget {
  final dynamic productData;

  const EditProductScreen({super.key, required this.productData});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _discPriceController;
  late TextEditingController _stockController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.productData['productName']);
    _priceController =
        TextEditingController(text: widget.productData['price'].toString());
    _discPriceController =
        TextEditingController(text: widget.productData['discPrice'].toString());
    _descController =
        TextEditingController(text: widget.productData['description']);
    _stockController = TextEditingController(text: widget.productData['stock']);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Edit Product"
              .text
              .size(19)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              "Product Name"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make()
                  // .px(6)
                  .px(22),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  // controller: emailController,
                  decoration: const InputDecoration(
                    // hintText: (user!.data() as dynamic)['userName'],
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                ),
              ).px16(),
              const SizedBox(
                height: 20,
              ),
              "Product Price"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make()
                  // .px(6)
                  .px(22),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  // controller: emailController,
                  decoration: const InputDecoration(
                    // hintText: (user!.data() as dynamic)['userName'],
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                ),
              ).px16(),
              const SizedBox(
                height: 20,
              ),
              "Discount Price"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make()
                  // .px(6)
                  .px(22),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  controller: _discPriceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  // controller: emailController,
                  decoration: const InputDecoration(
                    // hintText: (user!.data() as dynamic)['userName'],
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                ),
              ).px16(),
              const SizedBox(
                height: 20,
              ),
              "Product Description"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make()
                  // .px(6)
                  .px(22),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  controller: _descController,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                ),
              ).px16(),
              const SizedBox(
                height: 20,
              ),
              "Product Stock"
                  .text
                  .bold
                  .color(theamNotifier.isDark ? Colors.white : mainColor)
                  .size(16)
                  .make()
                  // .px(6)
                  .px(22),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                ),
                child: TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 154, 154, 154)),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                ),
              ).px16(),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await FirebaseFirestore.instance
                      .collection('AllProducts')
                      .doc(widget.productData['productId'])
                      .update({
                    'productName': _nameController.text,
                    'productNameLowercase': _nameController.text.toLowerCase(),
                    'price': double.parse(_priceController.text),
                    'discPrice': double.parse(_discPriceController.text),
                    'description': _descController.text,
                    'stock': _stockController.text,
                  });
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Product updated successfully!')),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9EE1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ).centered()
                      : "Save Changes"
                          .text
                          .color(Colors.white)
                          .size(18)
                          .bold
                          .make()
                          .centered(),
                ).px16(),
              ),
            ],
          ),
        ),
      );
    });
  }
}

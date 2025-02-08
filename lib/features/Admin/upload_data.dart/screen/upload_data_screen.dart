import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/methods/upload_firestore_methods.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:ecommerce_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:velocity_x/velocity_x.dart';

class AddProduct extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController discPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  bool isLoading = false;
  List<Uint8List> file = [];

  String categoryInitial = "Formal";
  String brandInitial = "Nike";
  String genderInitial = "Men";
  List<String> category = [
    "Formal",
    "Casual",
    "Running",
  ];
  List<String> gender = [
    "Men",
    "Women",
    "Unisex",
  ];
  List<String> brand = [
    "Nike",
    "Puma",
    "Adidas",
    "Converse",
    "Under Armour",
  ];
  Uint8List? images;
  // final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];

  // Array to store selected sizes
  // List<String> selectedSizes = [];
  final List<int> shoeSizes = [38, 39, 40, 41, 42, 43];
  List<int> selectedSizes = [];

  void openSizeSelector(TheamModal theamNotifier) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: shoeSizes.map((size) {
                return Container(
                  color: theamNotifier.isDark ? mainDarkColor : Colors.white,
                  child: CheckboxListTile(
                    // fillColor: Colors.amber,
                    activeColor: blueColor,
                    title: Text("Size $size"),
                    value: selectedSizes.contains(size),
                    onChanged: (bool? selected) {
                      setModalState(() {
                        if (selected == true) {
                          selectedSizes.add(size);
                        } else {
                          selectedSizes.remove(size);
                        }
                      });
                      setState(() {}); // Update the main state as well
                    },
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  final _addProductFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
  }

  void selectImages() async {
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      images = res;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(
      source: source,
    );

    if (file != null) {
      return await file.readAsBytes();
    }
  }

  pickMultiImage() async {
    final ImagePicker imagePicker = ImagePicker();

    final List<XFile> images = await imagePicker.pickMultiImage();
    // List<Uint8List> file = [];
    for (int i = 0; i < images.length; i++) {
      Uint8List fil = await images[i].readAsBytes();
      file.add(fil);
    }

    // print("image found ${file.length}");
    // return file;
  }

  void uploadProduct() async {
    setState(() {
      isLoading = true;
    });

    String res = await FirestoreMethods().uploadProduct(
      descriptionController.text,
      productNameController.text,
      double.parse(priceController.text),
      double.parse(discPriceController.text),
      file,
      stockController.text,
      categoryInitial,
      brandInitial,
      genderInitial,
      selectedSizes,
    );
    if (res == "success") {
      setState(() {
        priceController.clear();
        descriptionController.clear();
        productNameController.clear();
        images = null;
        priceController.clear();
        discPriceController.clear();
        brandNameController.clear();
        file = [];
        selectedSizes = [];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
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
              "Add New Product"
                  .text
                  .size(19)
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
        body: SingleChildScrollView(
          child: Form(
            key: _addProductFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                images != null
                    ? Container(
                        height: 180,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            image:
                                DecorationImage(image: MemoryImage(images!))),
                      )
                    : GestureDetector(
                        onTap: () {
                          pickMultiImage();
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: lightColor,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  color: lightColor,
                                  size: 40,
                                ),
                                "Select Product Image"
                                    .text
                                    .color(lightColor)
                                    .make(),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 28,
                ),
                CustomTextField(
                  controller: productNameController,
                  text: "Product Name",
                  hintText: "e.g Nike Jordon 2022",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: descriptionController,
                  text: "Description",
                  hintText: "e.g this product is so much flexible.....",
                  maxlines: 7,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: priceController,
                  text: "Price",
                  hintText: "e.g 230",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: discPriceController,
                  text: "Discount Price",
                  hintText: "e.g 180",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: stockController,
                  text: "Stock Available",
                  hintText: "e.g 40",
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Gender"
                        .text
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(16)
                        .bold
                        .make()
                        .px8(),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theamNotifier.isDark
                              ? mainDarkColor
                              : Colors.white),
                      child: Center(
                        child: DropdownButton(
                          value: genderInitial,
                          items: gender.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            setState(() {
                              genderInitial = val!;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          iconSize: 20,
                          style: TextStyle(
                              fontSize: 16,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Brand Name"
                        .text
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(16)
                        .bold
                        .make()
                        .px8(),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theamNotifier.isDark
                              ? mainDarkColor
                              : Colors.white),
                      child: Center(
                        child: DropdownButton(
                          value: brandInitial,
                          items: brand.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            setState(() {
                              brandInitial = val!;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          iconSize: 20,
                          style: TextStyle(
                              fontSize: 16,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Category"
                        .text
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(16)
                        .bold
                        .make()
                        .px8(),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theamNotifier.isDark
                              ? mainDarkColor
                              : Colors.white),
                      child: Center(
                        child: DropdownButton(
                          value: categoryInitial,
                          items: category.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            setState(() {
                              categoryInitial = val!;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          iconSize: 20,
                          style: TextStyle(
                              fontSize: 16,
                              color: theamNotifier.isDark
                                  ? Colors.white
                                  : Colors.black),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Size"
                        .text
                        .color(
                            theamNotifier.isDark ? Colors.white : Colors.black)
                        .size(16)
                        .bold
                        .make()
                        .px8(),
                    GestureDetector(
                      onTap: () {
                        openSizeSelector(theamNotifier);
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theamNotifier.isDark
                                ? mainDarkColor
                                : Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 20,
                            ),
                          ],
                        ).px16(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (productNameController.text.isNotEmpty &&
                        file.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        discPriceController.text.isNotEmpty &&
                        stockController.text.isNotEmpty &&
                        selectedSizes.isNotEmpty) {
                      uploadProduct();
                    } else {
                      showSnackBar(
                          "Please ensure all fields are completed!", context);
                    }
                  },
                  child: Container(
                    height: 58,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B9EE1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          ).centered()
                        : "Upload"
                            .text
                            .color(Colors.white)
                            .size(18)
                            .bold
                            .make()
                            .centered(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ).px16(),
          ),
        ),
      );
    });
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String hintText;
  final int maxlines;
  final bool isTrue;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.text,
    this.maxlines = 1,
    this.isTrue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text.text.bold
              .color(theamNotifier.isDark ? Colors.white : mainColor)
              .size(16)
              .make()
              .px8(),
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
              style: const TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 154, 154, 154)),
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      );
    });
  }
}

import 'package:ecommerce_app/features/shared/helperclass.dart';

class SharedClass {
  static List<Map<String, dynamic>> A = [];

  static void storeItemsToSharedPref() async {
    await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
  }

  static void updateListOfItems(List<Map<String, dynamic>> temp) {
    A = temp;
  }

  void pushItem(String name, String brandName, String price, String image,
      String productId, int size) async {
    if (A.isEmpty || !isItemPresent(productId)) {
      Map<String, dynamic> item = {};
      item["productName"] = name;
      item["brandName"] = brandName;
      item["productId"] = productId;
      item["price"] = price;
      item["imageUrl"] = image;
      item["quantity"] = 1;
      item["size"] = size;
      A.add(item);
      await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
    } else if (A.isNotEmpty && isItemPresent(productId)) {
      incrementItemCount(productId);
    } else {
      return;
    }
  }

  bool isItemPresent(String productId) {
    bool isPresent = false;
    if (A.isNotEmpty) {
      for (var i in A) {
        if (i["productId"] == productId) {
          isPresent = true;
          break;
        }
      }
    }
    return isPresent;
  }

  void incrementItemCount(String productId) async {
    for (var i in A) {
      if (i["productId"] == productId) {
        i["quantity"]++;
        await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
        break;
      }
    }
  }

  void removeProduct(String productId) async {
    if (A.isNotEmpty) {
      for (var item in A) {
        if (item["productId"] == productId) {
          A.remove(item);
          await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
          break;
        }
      }
    } else {
      return;
    }
  }

  void decrementItemCount(String productId) async {
    if (A.isNotEmpty) {
      for (var item in A) {
        if (item["productId"] == productId) {
          --item["quantity"];
          if (item["quantity"] == 0) {
            A.remove(item);
          }
          await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
          break;
        }
      }
    } else {
      return;
    }
  }

  void removeAllProduct() async {
    SharedClass.A = await SharedPreferencesHelper().retrieveListOfMaps();
    if (A.isNotEmpty) {
      for (var item in A) {
        A.remove(item);
      }
      SharedClass.A = [];
      await SharedPreferencesHelper().storeListOfMaps(SharedClass.A);
    } else {
      return;
    }
  }
}

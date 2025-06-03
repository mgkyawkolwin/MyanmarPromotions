import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class AppData{

  static void setAppData(Map<String, dynamic> appData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (appData.isNotEmpty) {
      appData.forEach((key, value) {
        switch (value.runtimeType) {
          case String:
            prefs.setString(key, value);
            break;
          case int:
            prefs.setInt(key, value);
            break;
          case double:
            prefs.setDouble(key, value);
            break;
          case bool:
            prefs.setBool(key, value);
            break;
        }
      });
    }
  }

  static void setAppDataByKey(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (data.runtimeType) {
      case String:
        prefs.setString(key, data);
        break;
      case int:
        prefs.setInt(key, data);
        break;
      case double:
        prefs.setDouble(key, data);
        break;
      case bool:
        prefs.setBool(key, data);
        break;
    }
  }

  static Future getAppData(List<String> keys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> myAppData = {};
    keys.forEach((element) {
      if (prefs.containsKey(element)) {
        myAppData[element] = prefs.get(element);
      }
    });
    if(!myAppData.containsKey('isAuth')){
      //myAppData['isAuth'] = false;
    }
    return myAppData;
  }

  static Future getAppDataAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> myAppData = {};
    prefs.getKeys().forEach((key) {
      if (prefs.containsKey(key)) {
        myAppData[key] = prefs.get(key);
      }
    });
    if(!myAppData.containsKey('isAuth')){
      //myAppData['isAuth'] = false;
    }
    return myAppData;
  }

  static Future getAppDataByKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.get(key);
    }
    else{
      return '';
    }
  }

  static void clearAppData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void addToCart(int shopItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shopping_cart')) {
      List<String>? shoppingList = prefs.getStringList('shopping_cart');
      shoppingList!.add(shopItemID.toString());
      prefs.setStringList('shopping_cart', shoppingList);
      print("Added to shopping cart.");
    } else {
      prefs.setStringList('shopping_cart', [shopItemID.toString()]);
      print("Added to shopping cart.");
    }
  }

  void removeFromCart(int shopItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shopping_cart')) {
      List<String>? cartList = prefs.getStringList('shopping_cart');

      if (cartList!.isNotEmpty) {
        if (cartList.contains(shopItemID.toString())) {
          if (cartList.remove(shopItemID.toString())) {
            if (cartList.isNotEmpty) {
              prefs.setStringList('shopping_cart', cartList);
            } else {
              prefs.remove('shopping_cart');
            }
          }
        }
      }
    }
  }

  Future shoppingCartList() async {
    List<String> shoppingList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shopping_cart')) {
      shoppingList = prefs.getStringList('shopping_cart')!;
    }
    return shoppingList;
  }

  void clearShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('shopping_cart');
    print("Clear shopping list");
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get ordersItems => [..._orders];

  String authToken = "";
  //String authUserId = "";

  void update(String tokenn /*, String userIdd*/) {
    this.authToken = tokenn;
    //this.authUserId = userIdd;
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final response = await http.get(Uri.parse(
        "https://test-2f016-default-rtdb.firebaseio.com/orders.json?auth=$authToken"));
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final List<OrderItem> loadedOrderData = [];
    final extractedOrderData = decodedResponse as Map<String, dynamic>;
    if (extractedOrderData == null) {
      return;
    }
    extractedOrderData.forEach((key, value) {
      loadedOrderData.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });

    _orders = loadedOrderData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    DateTime timeStamp = DateTime.now();
    final response = await http.post(
        Uri.parse(
            "https://test-2f016-default-rtdb.firebaseio.com/orders.json?auth=$authToken"),
        body: json.encode({
          'amount': totalAmount,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }));
    this._orders.add(OrderItem(
        id: json.decode(response.body)['name'],
        amount: totalAmount,
        products: cartProducts,
        dateTime: timeStamp));
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> changeFavouriteValue(String productId) async {
    final oldStatus = isFavourite;
    this.isFavourite = !isFavourite;
    notifyListeners();
    String uri =
        'https://test-2f016-default-rtdb.firebaseio.com/products/$productId.json';
    try {
      final response = await http.patch(Uri.parse(uri),
          body: json.encode({'isFavourite': isFavourite}));
      print(response.statusCode);
      if (response.statusCode >= 400) {
        this.isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      this.isFavourite = oldStatus;
      notifyListeners();
    }
  }
}

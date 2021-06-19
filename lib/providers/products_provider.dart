import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/models/httpException.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  // final String authToken;
  // ProductsProvider(this.authToken);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  //bool _showFavourites = false;
  String authToken = "";
  String authUserId = "";

  void update(String tokenn, String userIdd) {
    this.authToken = tokenn;
    this.authUserId = userIdd;
    notifyListeners();
  }

  List<Product> get items {
    // if (_showFavourites) {
    //   return _items.where((element) => element.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get showFavouritesItems {
    return [..._items.where((element) => element.isFavourite).toList()];
  }

  Product searchItemByID(String id) {
    return this._items.firstWhere((element) => element.id == id);
  }

  Future<void> fecthAndSetProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$authUserId"' : '';
    try {
      final response = await http.get(Uri.parse(
          'https://test-2f016-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString'));
      var extractedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      if (extractedResponse == null) {
        return;
      }
      String userFavouriteUri =
          'https://test-2f016-default-rtdb.firebaseio.com/userFavourite/$authUserId/.json?auth=$authToken';
      final favouriteRespose = await http.get(Uri.parse(userFavouriteUri));
      final favouriteData = json.decode(favouriteRespose.body);
      extractedResponse.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageURL'],
            isFavourite:
                favouriteData == null ? false : favouriteData[value] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
      print(extractedResponse);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    //continue here
    try {
      var response = await http.post(
          Uri.parse(
              'https://test-2f016-default-rtdb.firebaseio.com/products.json?auth=$authToken'),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageURL': product.imageUrl,
            'price': product.price,
            'creatorId': authUserId
          }));

      var extractedResponse = json.decode(response.body);
      print(extractedResponse["name"]);
      final newProduct = Product(
          id: extractedResponse["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      this._items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    String uri =
        'https://test-2f016-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    http.patch(Uri.parse(uri),
        body: json.encode({
          'description': newProduct.description,
          'title': newProduct.title,
          'price': newProduct.price,
          'imageURL': newProduct.imageUrl,
        }));
    final prodctIndex = this._items.indexWhere((element) => element.id == id);
    if (prodctIndex >= 0) {
      _items[prodctIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String productId) async {
    String uri =
        'https://test-2f016-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    Product existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(uri));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    existingProduct = null;
  }

  // void showFavouritesOnly() {
  //   _showFavourites = true;
  //   notifyListeners();
  // }

  // void showAllOnly() {
  //   _showFavourites = false;
  //   notifyListeners();
  // }
}

import 'package:flutter/widgets.dart';
import 'package:shopapp/providers/productsModels.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  bool _showFavourites = false;

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

  void addProduct(List<Product> item) {
    this._items = item;
    notifyListeners();
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:shopapp/widgets/gridTile.dart';
import 'package:shopapp/providers/products_provider.dart';

class ProductsGridView extends StatefulWidget {
  final bool favouriteData;

  const ProductsGridView({Key key, this.favouriteData}) : super(key: key);
  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    List<Product> loadedProducts = widget.favouriteData
        ? productsData.showFavouritesItems
        : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<Product>.value(
          value: loadedProducts[index],
          child: ProductsGridTile(),
        );
      },
    );
  }
}

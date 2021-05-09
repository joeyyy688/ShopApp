import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/productsModels.dart';
import 'package:shopapp/models/widgets/gridTile.dart';
import 'package:shopapp/providers/products_provider.dart';

class ProductsGridView extends StatefulWidget {
  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    List<Product> loadedProducts = productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ProductsGridTile(
          id: loadedProducts[index].id,
          title: loadedProducts[index].title,
          imageUrl: loadedProducts[index].imageUrl,
        );
      },
    );
  }
}

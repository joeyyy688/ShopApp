import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/widgets/productsGridView.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:shopapp/providers/products_provider.dart';

enum FilterOption { Favourite, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Only Favourite'),
                  value: FilterOption.Favourite,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOption.All,
                ),
              ];
            },
            onSelected: (FilterOption value) {
              switch (value) {
                case FilterOption.Favourite:
                  product.showFavouritesOnly();
                  break;
                default:
                  product.showAllOnly();
                  break;
              }
            },
          )
        ],
      ),
      body: ProductsGridView(),
    );
  }
}

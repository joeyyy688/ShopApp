import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import 'package:shopapp/models/widgets/productsGridView.dart';
import 'package:shopapp/pages/cartPage.dart';
import 'package:shopapp/providers/cart.dart';
// import 'package:shopapp/providers/productsModels.dart';
// import 'package:shopapp/providers/products_provider.dart';

enum FilterOption { Favourite, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool showOnlyFavouritesData = false;
  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<ProductsProvider>(context);
    //final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: [
          Consumer<Cart>(
            builder: (context, cartValue, child) {
              return Badge(
                //ignorePointer: true,
                padding: EdgeInsets.all(8),
                shape: BadgeShape.circle,
                badgeColor: Colors.red,
                badgeContent: Text("${cartValue.items.length.toString()}"),
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
            ),
          ),
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
              setState(() {
                switch (value) {
                  case FilterOption.Favourite:
                    showOnlyFavouritesData = true;
                    //product.showFavouritesOnly();
                    break;
                  default:
                    showOnlyFavouritesData = false;
                    //product.showAllOnly();
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: ProductsGridView(
        favouriteData: showOnlyFavouritesData,
      ),
    );
  }
}

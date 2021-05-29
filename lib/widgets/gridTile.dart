import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/products_details.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/productsModels.dart';

class ProductsGridTile extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductsGridTile({Key key, this.id, this.title, this.imageUrl})
  //     : super(key: key);
  @override
  _ProductsGridTileState createState() => _ProductsGridTileState();
}

class _ProductsGridTileState extends State<ProductsGridTile> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductsDetails.routeName, arguments: products.id);
        },
        child: GridTile(
          child: Image.network(
            products.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(products.isFavourite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    products.changeFavouriteValue();
                  },
                );
              },
            ),
            backgroundColor: Colors.black87,
            title: Text(
              products.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(products.id, products.price, products.title);
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProductsGridTile extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductsGridTile({Key key, this.id, this.title, this.imageUrl})
      : super(key: key);
  @override
  _ProductsGridTileState createState() => _ProductsGridTileState();
}

class _ProductsGridTileState extends State<ProductsGridTile> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon: Icon(Icons.favorite_rounded),
          onPressed: () {},
        ),
        backgroundColor: Colors.black87,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
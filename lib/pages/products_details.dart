import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:shopapp/providers/products_provider.dart';

class ProductsDetails extends StatefulWidget {
  static const routeName = '/products_details';
  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  @override
  Widget build(BuildContext context) {
    String productID = ModalRoute.of(context).settings.arguments as String;
    Product selectedProductData =
        Provider.of<ProductsProvider>(context).searchItemByID(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProductData.title),
      ),
      //body: ,
    );
  }
}

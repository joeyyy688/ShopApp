import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/widgets/app_Drawer.dart';

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
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(selectedProductData.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              child: Image.network(
                selectedProductData.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                '\$${selectedProductData.price}',
                style: TextStyle(fontSize: 25, color: greyColor),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                '${selectedProductData.description}',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

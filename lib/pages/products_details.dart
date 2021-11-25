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
      // appBar: AppBar(
      //   title: Text(selectedProductData.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProductData.title),
              background: Hero(
                tag: selectedProductData.id,
                child: Image.network(
                  selectedProductData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                '\$ ${selectedProductData.price}',
                style: TextStyle(fontSize: 25, color: greyColor),
                textAlign: TextAlign.center,
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
            ),
            SizedBox(
              height: 800,
            ),
          ]))
        ],
      ),
    );
  }
}

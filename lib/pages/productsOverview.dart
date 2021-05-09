import 'package:flutter/material.dart';
import 'package:shopapp/models/widgets/productsGridView.dart';

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
      ),
      body: ProductsGridView(),
    );
  }
}

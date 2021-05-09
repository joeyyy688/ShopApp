import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/productsOverview.dart';
import 'package:shopapp/pages/products_details.dart';
import 'package:shopapp/providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsProvider>.value(
      value: ProductsProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          ProductsDetails.routeName: (context) => ProductsDetails(),
        },
      ),
    );
  }
}

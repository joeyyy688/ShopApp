import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/auth_screen.dart.dart';
import 'package:shopapp/pages/cartPage.dart';
import 'package:shopapp/pages/editProductPage.dart';
import 'package:shopapp/pages/ordersPage.dart';
import 'package:shopapp/pages/productsOverview.dart';
import 'package:shopapp/pages/products_details.dart';
import 'package:shopapp/pages/userProductsPage.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(value: Auth()),
          ChangeNotifierProvider<ProductsProvider>.value(
            value: ProductsProvider(),
          ),
          ChangeNotifierProvider<Cart>.value(value: Cart()),
          ChangeNotifierProvider<Orders>.value(value: Orders()),
        ],
        child: Consumer<Auth>(
          builder: (context, authData, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: authData.isAuth ? ProductsOverview() : AuthScreen(),
              routes: {
                ProductsOverview.routeName: (context) => ProductsOverview(),
                ProductsDetails.routeName: (context) => ProductsDetails(),
                CartPage.routeName: (context) => CartPage(),
                OrdersPage.routeName: (context) => OrdersPage(),
                UserProductsPage.routeName: (context) => UserProductsPage(),
                EditProductPage.routeName: (context) => EditProductPage(),
              },
            );
          },
        ));
  }
}

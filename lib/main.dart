import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/auth_screen.dart.dart';
import 'package:shopapp/pages/cartPage.dart';
import 'package:shopapp/pages/editProductPage.dart';
import 'package:shopapp/pages/ordersPage.dart';
import 'package:shopapp/pages/productsOverview.dart';
import 'package:shopapp/pages/products_details.dart';
import 'package:shopapp/pages/splash_page.dart.dart';
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
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (context) => ProductsProvider(),
            update: (context, auth, previousValue) =>
                previousValue..update(auth.token, auth.userID),
          ),
          // ChangeNotifierProvider<ProductsProvider>.value(
          //   value: ProductsProvider(),
          // ),
          ChangeNotifierProvider<Cart>.value(value: Cart()),
          // ChangeNotifierProvider<Orders>.value(value: Orders()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(),
            update: (context, auth, previousValue) =>
                previousValue..update(auth.token, auth.userID),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, authData, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
              ),
              home: authData.isAuth
                  ? ProductsOverview()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
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

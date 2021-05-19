import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Card(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      'Total',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  Spacer(),
                  Consumer<Cart>(
                    builder: (context, cartValue, child) {
                      return Chip(
                          backgroundColor: Theme.of(context).primaryColor,
                          label: Text(
                            '\$ ${cartValue.totalAmount}',
                            style: TextStyle(color: Colors.white),
                          ));
                    },
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

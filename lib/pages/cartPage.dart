import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/constants/colors.dart';
import 'package:shopapp/providers/cart.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 140,
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
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$ ${cart.totalAmount}',
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(cart.items.values.toList()[index].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Theme.of(context).errorColor,
                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: whiteColor,
                      size: 40,
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  cart.removeItem(cart.items.values.toList()[index].id);
                  print(cart.items.length);
                },
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: FittedBox(
                            child: Text(
                                '\$${cart.items.values.toList()[index].price}')),
                      ),
                      title: Text(
                        '${cart.items.values.toList()[index].title}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                          'Total: \$${cart.items.values.toList()[index].price * cart.items.values.toList()[index].quantity}'),
                      trailing: Text(
                        '${cart.items.values.toList()[index].quantity} x',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}

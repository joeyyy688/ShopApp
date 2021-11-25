import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cartPage';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    final orders = Provider.of<Orders>(context, listen: true);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('MyShop - Cart'),
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
                        '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: cart.totalAmount <= 0 || isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              await orders.addOrder(
                                  cart.items.values.toList(), cart.totalAmount);
                              setState(() {
                                isLoading = false;
                              });
                              cart.clearCart();
                            },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'ORDER NOW',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
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
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure"),
                        content: Text('Do you want to remove item from cart?'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                              //Navigator.pop(context);
                              //return Future.value(false);
                            },
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                                //Navigator.pop(context);
                                //return Future.value(true);
                              },
                              child: Text('Yes'))
                        ],
                      );
                    },
                  );
                },
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
                                '\$ ${cart.items.values.toList()[index].price}')),
                      ),
                      title: Text(
                        '${cart.items.values.toList()[index].title}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                          'Total: \$ ${cart.items.values.toList()[index].price * cart.items.values.toList()[index].quantity}'),
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

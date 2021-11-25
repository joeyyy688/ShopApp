import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/widgets/app_Drawer.dart';
import 'dart:math';

class OrdersPage extends StatefulWidget {
  static const routeName = '/ordersPage';
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _expanded = false;
  //bool isLoading = false;

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   Future.delayed(Duration.zero, () async {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickShop Lite - Orders'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: FutureBuilder(
              future: Provider.of<Orders>(context, listen: false)
                  .fetchAndSetOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("An Error Occured"),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (context, ordersData, child) {
                        return ListView.builder(
                          itemCount: ordersData.ordersItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        'Total: GHS ${ordersData.ordersItems[index].amount.toStringAsFixed(2)}'),
                                    subtitle: Text(
                                        '${DateFormat('EEE, ' ' MMM d, ' 'yyyy h:mm a').format(ordersData.ordersItems[index].dateTime)}'),
                                    trailing: IconButton(
                                      icon: Icon(_expanded
                                          ? Icons.expand_less_outlined
                                          : Icons.expand_more),
                                      onPressed: () {
                                        setState(() {
                                          _expanded = !_expanded;
                                        });
                                      },
                                    ),
                                  ),
                                  if (_expanded)
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: min(
                                          ordersData.ordersItems[index].products
                                                      .length *
                                                  20.0 +
                                              20.0,
                                          300),
                                      child: ListView(
                                        children: ordersData
                                            .ordersItems[index].products
                                            .map((element) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${element.title}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${element.quantity} x GHS ${element.price}',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: greyColor),
                                                    )
                                                  ],
                                                ))
                                            .toList(),
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }
              },
            )),
      ),
    );
  }
}

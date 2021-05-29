import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/widgets/app_Drawer.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/ordersPage';
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: 400,
          child: ListView.builder(
            itemCount: ordersData.ordersItems.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('\$${ordersData.ordersItems[index].amount}'),
                      subtitle: Text(
                          '${DateFormat('EEE, ' ' MMM d, ' 'yyyy h:mm a').format(ordersData.ordersItems[index].dateTime)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.expand_more),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

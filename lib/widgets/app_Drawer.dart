import 'package:flutter/material.dart';
import 'package:shopapp/pages/ordersPage.dart';
import 'package:shopapp/pages/userProductsPage.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Widget _buildDrawer(
      {@required String title,
      @required Function onTapHandler,
      @required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: onTapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello User'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          _buildDrawer(
            icon: Icon(Icons.shop),
            title: 'Shop',
            onTapHandler: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          _buildDrawer(
            icon: Icon(Icons.payment),
            title: 'Order',
            onTapHandler: () {
              Navigator.of(context).pushReplacementNamed(OrdersPage.routeName);
            },
          ),
          Divider(),
          _buildDrawer(
            icon: Icon(Icons.edit),
            title: 'Manage Products',
            onTapHandler: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsPage.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

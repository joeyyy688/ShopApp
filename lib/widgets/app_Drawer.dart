import 'package:flutter/material.dart';
import 'package:shopapp/pages/ordersPage.dart';

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
            title: Text('Hello Friend'),
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
          _buildDrawer(
            icon: Icon(Icons.payment),
            title: 'Order',
            onTapHandler: () {
              Navigator.of(context).pushReplacementNamed(OrdersPage.routeName);
            },
          )
        ],
      ),
    );
  }
}

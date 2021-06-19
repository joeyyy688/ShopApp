import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/editProductPage.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/widgets/app_Drawer.dart';

class UserProductsPage extends StatefulWidget {
  static const routeName = '/userProductsPage';
  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  Future<void> refreshPage(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fecthAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductsProvider>(context, listen: true);
    print("rebuilding");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              ///code
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshPage(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => refreshPage(context),
                color: Theme.of(context).primaryColor,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                strokeWidth: 3,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Consumer<ProductsProvider>(
                      builder: (context, productsData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      productsData.items[index].imageUrl),
                                ),
                                title: Text(productsData.items[index].title),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              EditProductPage.routeName,
                                              arguments:
                                                  productsData.items[index].id);
                                        },
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await productsData.deleteProduct(
                                                productsData.items[index].id);
                                          } catch (e) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  'Item Could not be deleted'),
                                              duration: Duration(seconds: 5),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                          //print(index);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
              ),
      ),
    );
  }
}

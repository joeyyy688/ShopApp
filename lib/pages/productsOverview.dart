import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/widgets/app_Drawer.dart';
//import 'package:provider/provider.dart';
import 'package:shopapp/widgets/productsGridView.dart';
import 'package:shopapp/pages/cartPage.dart';
import 'package:shopapp/providers/cart.dart';
// import 'package:shopapp/providers/productsModels.dart';
// import 'package:shopapp/providers/products_provider.dart';

enum FilterOption { Favourite, All }

class ProductsOverview extends StatefulWidget {
  static const routeName = '/productsOverview';
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool showOnlyFavouritesData = false;
  bool isInit = true;
  bool isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero, () {
    //   Provider.of<ProductsProvider>(context).fecthAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fecthAndSetProducts()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<ProductsProvider>(context);
    //final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickShop Lite'),
        actions: [
          Consumer<Cart>(
            builder: (context, cartValue, child) {
              return Badge(
                //ignorePointer: true,
                padding: EdgeInsets.all(8),
                shape: BadgeShape.circle,
                badgeColor: Colors.red,
                badgeContent: Text("${cartValue.items.length.toString()}"),
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Only Favourite'),
                  value: FilterOption.Favourite,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOption.All,
                ),
              ];
            },
            onSelected: (FilterOption value) {
              setState(() {
                switch (value) {
                  case FilterOption.Favourite:
                    showOnlyFavouritesData = true;
                    //product.showFavouritesOnly();
                    break;
                  default:
                    showOnlyFavouritesData = false;
                    //product.showAllOnly();
                    break;
                }
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: ProductsGridView(
                    favouriteData: showOnlyFavouritesData,
                  ),
                ),
                buildFloatingSearchBar(),
              ],
            ),
    );
  }
}

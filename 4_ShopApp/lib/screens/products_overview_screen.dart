import 'package:shop_app/providers/products_provider.dart';

import '../widgets/app_drawer.dart';

import '../providers/cart_provider.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;
  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    //Provider.of<ProductsProvider>(context).fetchAndSetProducts(); this wownt work
    // maybe with listen: false, but in init state not everithing is wired up yet
    // nice hack (related to dart version of event loop)
    // Future.delayed(Duration.zero).then((_) =>
    //   Provider.of<ProductsProvider>(context).fetchAndSetProducts()
    // );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() => isLoading = true);
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() => isLoading = false);
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            initialValue: FilterOptions.All,
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _showFavoritesOnly = selectedValue == FilterOptions.Favorites;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, cartProvider, ch) => Badge(
              child: ch,
              value: cartProvider.itemCount.toString(),
            ),
            child: IconButton(
              // a widget that does not rebuild that ends up as the child in the builder function
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}

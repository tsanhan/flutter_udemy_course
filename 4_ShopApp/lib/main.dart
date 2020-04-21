import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import './screens/edit_product.dart';
import './screens/user_products_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import 'helpers/custom_route.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: null,
    //   builder: (ctx) => ProductsProvider(),

    // an alternative way if provider does not depend on the context
    /* 
    should use it to fix issue with fluttr in witch widgets are recycled by flatterer but the data that's attached to the widget
    changes.
    when using ChangeNotifyProvider.Value you actually make sure that the provider works
    even if data changes for the widget.
    If you had a builder function, that would not work correctly here it will work correctly because now
    the provider is tied to its data and is attached and detached to and from the widget instead of changing
    data being attached to the same provider.
    So this .Value constructor syntax is the approach you should use in this scenario here and in all
    scenarios where you have the provider package and you're providing your data on single list or grid
    items where flatter then actually will recycle the widgets you're attaching your provider to.
    With this .Value constructor approach Dad will work without issues with the builder function
    we used before that would couse bugs as soon as you have more items that do actually go beyond the screen boundaries,
    because of the way widgets are recycled and your data changes and your provider wouldn't keep up with that, 
    the .Value constructor will keep up with that.
    That's just a little side note
    */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),

        // a provider that depends on another provider
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: null,
            update: (ctx, auth, previousProductsProvider) => ProductsProvider(
                auth.token,
                previousProductsProvider == null
                    ? []
                    : previousProductsProvider.items,
                auth.userId)),
        ChangeNotifierProvider.value(value: CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: null,
          update: (ctx, auth, previousOrdersProvider) => OrdersProvider(
              auth.token,
              previousOrdersProvider == null
                  ? []
                  : previousOrdersProvider.orders,
              auth.userId),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            }),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutologin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(auth.token),
          },
        ),
      ),
    );
  }
}

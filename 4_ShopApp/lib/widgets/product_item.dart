import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  ProductItem();

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    Widget _buildGesture(Widget child) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: child);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: _buildGesture(
          Hero(
              tag: product.id,
              child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
               fit: BoxFit.cover,
              
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Consumer makes it's content to listen even if the [Provider.of<Product>(context);] on top will have listen: false
          leading: Consumer<Product>(
            builder: (ctx, product, _ /**no need for this here */) =>
                IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => product.toggleFavoriteStatus(authData.token, authData.userId ),
              color: Theme.of(context).accentColor,
            ),
            child: Text(
                'Never Changes'), // a widget that does not rebuild that ends up as the child in the builder function
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItem(product);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'adding ${product.title}',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => cartProvider.removeItem(
                      product: product, reMoveAll: false),
                ),
              )); // connection to the nearest Scaffold
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        header: _buildGesture(
          Container(
              color: Colors.black54,
              padding: EdgeInsets.all(5),
              child: Text(
                '\$${product.price}',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}

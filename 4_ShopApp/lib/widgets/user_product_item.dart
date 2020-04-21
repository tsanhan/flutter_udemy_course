import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  const UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context)
                .pushNamed(EditProductScreen.routeName, arguments: product),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(product);
              } catch (e) {
                scaffold.showSnackBar(SnackBar(
                    content: Text(
                  "Deleteting failed!",
                  textAlign: TextAlign.center,
                )));
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}

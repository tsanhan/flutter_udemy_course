
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_item.dart';



class ProductsGrid extends StatelessWidget {
  bool showFavoritesOnly;
  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =  showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length, 
      itemBuilder: (ctx,i) => 
      // ChangeNotifierProvider(
      //   child: ProductItem(),
      //   builder: (c) => products[i]

        // an alternative way if provider does not depend on the context
        ChangeNotifierProvider.value(
          child: ProductItem(),
          value: products[i], 
        ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2, // little higher then they are wide
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
        ),
      );
  }
}

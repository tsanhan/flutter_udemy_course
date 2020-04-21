import 'package:flutter/material.dart';
import '../widgets/category_item.dart';
import '../dummy_data.dart';




class CategoriesScreen extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return  
      GridView(
        padding: const EdgeInsets.all(25),
        children: DUMMY_CATEGORIES.map((cat) => CategoryItem(cat)).toList(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.5,
          crossAxisSpacing: 20,
          mainAxisSpacing:  20
          )
    );
  }
}
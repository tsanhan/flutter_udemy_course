import 'package:flutter/material.dart';
import '../screens/category_meals_screen.dart';
import '../models/category.dart';



class CategoryItem extends StatelessWidget {
  


  final Category cat;

  const CategoryItem(this.cat);


  void _selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryMealsSceen.routeName, 
      arguments: {'cat': cat});
  }
  //   Navigator.of(ctx).push(MaterialPageRoute(
  //     builder: (_) {
  //       return CategoryMealsSceen(cat);
  //     }
  //   ));
  // }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>_selectCategory (context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          cat.title,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cat.color.withOpacity(0.7),
              cat.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
            ),
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}
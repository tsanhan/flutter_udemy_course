import '../widgets/meal_item.dart';
import '../models/meal.dart';

import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {

Set<Meal> favoritesMeals;
FavoritesScreen(this.favoritesMeals);

  @override
  Widget build(BuildContext context) {
    if(favoritesMeals.isEmpty)
      return Center(
        child: Text("You Have No Favorites yet - start adding some"),
      );

    return ListView.builder(
        itemBuilder: (ctx, i) {
          return MealItem(favoritesMeals.toList()[i], /*removeMeal*/);
        },
        itemCount: favoritesMeals.length,
        );
  }
}

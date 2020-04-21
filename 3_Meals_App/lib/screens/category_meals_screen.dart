import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';
import '../models/category.dart';


class CategoryMealsSceen extends StatefulWidget {
  static const routeName = '/category-meals';
  
  final List<Meal> availableMeals;
  CategoryMealsSceen(this.availableMeals);
  @override
  _CategoryMealsSceenState createState() => _CategoryMealsSceenState();
}

class _CategoryMealsSceenState extends State<CategoryMealsSceen> {

  List<Meal> meals;
  Category cat;
  bool _loadedInitDate = false;

  @override
  void didChangeDependencies() {
    if(!_loadedInitDate){

      final routrArgs = ModalRoute.of(context).settings.arguments as Map<String,Object>;
      cat = routrArgs['cat'];
      meals = widget.availableMeals.where((m) => m.categories.contains(cat.id)).toList();
      super.didChangeDependencies();
      _loadedInitDate = true;
    }
  }
  
  void removeMeal(Meal meal){
    setState(() {
      meals.remove(meal);
    });
  }

  @override
  Widget build(BuildContext context) {
    
     
    return  Scaffold(
      appBar: AppBar(
        title: Text(cat.title),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return MealItem(meals[i], /*removeMeal*/);
        },
          itemCount: meals.length, 
        )
      );
  }
}
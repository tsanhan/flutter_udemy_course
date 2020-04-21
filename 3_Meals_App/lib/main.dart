import './dummy_data.dart';
import './models/meal.dart';
import './models/filters.dart';
import './screens/filters_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/tabs_screen.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

  class _MyAppState extends State<MyApp> {
  var _filters = Filters(
    isGlutenFree: false,
    isLactoseFree: false,
    isVegan: false,
    isVegetarian: false
  );  

  void _setFilters (Filters filters){
    this._filters = filters;
    this._availableMeals = DUMMY_MEALS.where((m) {
        if(_filters.isGlutenFree && !m.filters.isGlutenFree)
          return false;
        if(_filters.isLactoseFree && !m.filters.isLactoseFree)
          return false;
        if(_filters.isVegan && !m.filters.isVegan)
          return false;
        if(_filters.isVegetarian && !m.filters.isVegetarian)
          return false;
        return true;
      }).toList();
  }

  List<Meal> _availableMeals = DUMMY_MEALS;  
  Set<Meal> _favoriteMeals = Set<Meal>() ;

  void _toggleMeal(Meal meal){
    setState(() {
        if(_favoriteMeals.contains(meal)){
          _favoriteMeals.remove(meal);
          return;
        }
        _favoriteMeals.add(meal);
    });
  }
  
  bool _isFavoriteMeal(Meal meal){
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Deli Meals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
          body1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          ),
          body2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          ),
          title: TextStyle(
            fontSize: 24,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold
          )
        )

      ),
      //home: CategoriesScreen(),
      initialRoute: '/', // default is '/
      routes: {
        '/':(ctx) => TabsScreen(_favoriteMeals),
        CategoryMealsSceen.routeName: (ctx) => CategoryMealsSceen(_availableMeals),
        MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(_toggleMeal, _isFavoriteMeal),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_setFilters,_filters),
        
      },
      // logic to execute for any route net registered in routes
      // if I have routes that are created dynamically...
      // onGenerateRoute: (setting) {
      //   if(setting.name == '/meal-detail'){
      //     return ...
      //   } else if(setting.name == '/something-else'){
      //     return ...
      //   }
      //   return MaterialPageRoute(
      //     builder: (ctx) => CategoriesScreen()
      //   );
      // },  

      // when flutter failed to generate creeen with al other ways
      // last fallback
      onUnknownRoute: (setting) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen()
        );
      },  
    );
  }
}


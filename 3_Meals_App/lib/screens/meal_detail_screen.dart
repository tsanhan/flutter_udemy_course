import 'package:flutter/material.dart';
//import '../dummy_data.dart';
import '../models/meal.dart';

class MealDetailsScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  final Function toggleMeal;
  final Function isFavoriteMeal;
  MealDetailsScreen(this.toggleMeal, this.isFavoriteMeal);

  Widget buidSectionTitle(BuildContext ctx, String tuitle){
    return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tuitle,
                      style: Theme.of(ctx).textTheme.title,
                    ),
                  );
  }

  Widget buildContailer(Widget child){
  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    child: child,
                  );
                  
}

  
  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context).settings.arguments as Meal;

    //final selectedMeal = DUMMY_MEALS.firstWhere((m) => m.id == meal.id);
    final appBar = AppBar(
      title: Text(meal.title),
    );
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Image.network(meal.imageUrl, fit: BoxFit.cover),
                    ),
                    buidSectionTitle(context, 'Ingredients'),
                    buildContailer(ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Card(
                            color: Theme.of(context).accentColor,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(meal.ingredients[i])),
                          );
                        },
                        itemCount: meal.ingredients.length,
                      ),
                    ),
                    buidSectionTitle(context, 'Steps'),
                    buildContailer(ListView.builder(
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    child: Text('# ${i+1}'),
                                  ),
                                  title: Text(meal.steps[i])
                                ),
                                Divider()
                              ],

                            );
                          },
                          itemCount: meal.steps.length,
                        ),
                                      )
                  
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(isFavoriteMeal(meal) ? Icons.star: Icons.star_border),
          onPressed: () => toggleMeal(meal),),
    );
            
  }        
}

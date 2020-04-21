import 'package:flutter/material.dart';

import '../screens/meal_detail_screen.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {

final Meal meal;
//final Function removeItem;
const MealItem(
  @required this.meal,
  //@required this.removeItem,
  
   );

  void selectMeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      MealDetailsScreen.routeName,
      arguments: meal
      ).then((result) { // result is execyted when the page is done with
        // check if result has a value (the creen can be done with by number of reasons - like the back button in appbar) 
        if(result != null){
          //removeItem(result);
        }
      });
  }

  String get complexityText {
    switch (meal.complexity) {
      case Complexity.Simple :
        return 'Simple';
        break;
      case Complexity.Hard :
        return 'Hard';
        break;
      case Complexity.Challenging :
        return 'Challenging';
        break;
      
      default:
        return '';
    }
  } 
  String get affordabilityText {
    switch (meal.affordability) {
      case Affordability.Affordable :
        return 'Affordable';
        break;
      case Affordability.Luxurious :
        return 'Luxurious';
        break;
      case Affordability.Pricey :
        return 'Pricey';
        break;
      
      default:
        return '';
    }
  } 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15), 
                    topRight: Radius.circular(15)),
                  child: Image.network(meal.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          ),
                 ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    width: 300,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20),

                    child: Text(meal.title,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.schedule),
                      SizedBox(width: 6,),
                      Text('${meal.duration} min')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.work),
                      SizedBox(width: 6,),
                      Text('$complexityText')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.attach_money),
                      SizedBox(width: 6,),
                      Text('$affordabilityText')
                    ],
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
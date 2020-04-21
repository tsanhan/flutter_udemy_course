import 'package:flutter/foundation.dart';
import '../models/filters.dart';

enum  Complexity{
  Simple,
  Challenging,
  Hard
}

enum  Affordability {
  Affordable,
  Pricey,
  Luxurious
}

class Meal {
  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final Filters filters;

  const Meal({
    @required this.affordability,
    @required this.categories,
    @required this.complexity,
    @required this.duration,
    @required this.id,
    @required this.imageUrl,
    @required this.ingredients,
    @required this.filters,
    @required this.steps,
    @required this.title,
  });
  

}
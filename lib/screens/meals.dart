import 'package:flutter/material.dart';
import 'package:meals/models/meals.dart';
import 'package:meals/screens/meals_detail_screen.dart';
import 'package:meals/widget/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    required this.meals,
    required this.toggleFavouriteMeal,
  });

  final List<Meal> meals;
  final void Function(Meal meal) toggleFavouriteMeal;

  void onSelectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsDetailScreen(
          meal: meal,
          toggleFavouriteMeal: toggleFavouriteMeal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Uh oh... nothing here.....',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Try selecting a different category',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ]),
    );

    if (meals.isNotEmpty) {
      content = ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) => MealItem(
                meal: meals[index],
                onSelectMeal: (meal) {
                  onSelectMeal(context, meal);
                },
              ));
    }

    return Scaffold(
      body: content,
    );
  }
}

import 'package:flutter/material.dart';
import 'MealCard.dart';

class MealsPage extends StatelessWidget {
  final List<dynamic> meals;

  const MealsPage({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: meals.isEmpty
          ? Center(child: Text('No meals available.'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealCard(meal: meal);
              },
            ),
    );
  }
}

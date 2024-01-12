import 'package:flutter/material.dart';
import 'package:meals/models/meals.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widget/main_drawer.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int selectedIndex = 0;
  List<Meal> favouriteMeal = [];

  onSelectTab(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        message,
      )),
    );
  }

  toggleFavouriteMeal(Meal meal) {
    final isExisting = favouriteMeal.contains(meal);

    if (isExisting) {
      setState(() {
        favouriteMeal.remove(meal);
      });
      _showMessage('Meal is no longer a favourite');
    } else {
      setState(() {
        favouriteMeal.add(meal);
      });
      _showMessage('Meal added to favourite');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      toggleFavouriteMeal: toggleFavouriteMeal,
    );
    String activePageTitle = 'Categories';

    if (selectedIndex == 1) {
      activePage = MealsScreen(
        title: '',
        meals: favouriteMeal,
        toggleFavouriteMeal: toggleFavouriteMeal,
      );
      activePageTitle = 'Meals';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: const MainDrawer(),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onSelectTab,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favourites',
          )
        ],
      ),
    );
  }
}

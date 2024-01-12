import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meals.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widget/main_drawer.dart';

const kInitialFilters = {
  Filters.glutonFree: false,
  Filters.lactosFree: false,
  Filters.vegeterian: false,
  Filters.vegan: false,
};

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int selectedIndex = 0;
  List<Meal> favouriteMeal = [];
  Map<Filters, bool> _selectedFilters = kInitialFilters;

  onSelectTab(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        message,
      )),
    );
  }

  void _selectScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(
          builder: (context) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
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
    List<Meal> availableMeals = dummyMeals.where((meals) {
      if (_selectedFilters[Filters.glutonFree]! && !meals.isGlutenFree) {
        return false;
      }

      if (_selectedFilters[Filters.lactosFree]! && !meals.isLactoseFree) {
        return false;
      }

      if (_selectedFilters[Filters.vegan]! && !meals.isVegan) {
        return false;
      }

      if (_selectedFilters[Filters.vegeterian]! && !meals.isVegetarian) {
        return false;
      }

      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      toggleFavouriteMeal: toggleFavouriteMeal,
      filteredMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    if (selectedIndex == 1) {
      activePage = MealsScreen(
        meals: favouriteMeal,
        toggleFavouriteMeal: toggleFavouriteMeal,
      );
      activePageTitle = 'Favourite Meals';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        selectScreen: _selectScreen,
      ),
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

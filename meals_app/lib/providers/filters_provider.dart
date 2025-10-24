import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class filtersNotifier extends StateNotifier<Map<Filter, bool>> {
  filtersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });

  void setFilters(Map<Filter, bool> chosenfilters) {
    state = chosenfilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<filtersNotifier, Map<Filter, bool>>(
      (ref) => filtersNotifier(),
    );

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activefilter = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activefilter[Filter.glutenFree]! && meal.isGlutenFree) {
      return false;
    }
    if (activefilter[Filter.lactoseFree]! && meal.isLactoseFree) {
      return false;
    }
    if (activefilter[Filter.vegetarian]! && meal.isVegetarian) {
      return false;
    }
    if (activefilter[Filter.vegan]! && meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});

import 'package:boltgrocery/DataModels/grocery_item.dart';
import 'package:boltgrocery/LocalDatabase/local_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class GroceriesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<GroceryItem> groceries = <GroceryItem>[].obs;

  AnimationController? _animationController;
  Animation<RelativeRect>? animation;
  Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
  bool isThemeDark = false;

  LocalDatabase _localDatabase = LocalDatabase();
  int? itemCount;
  @override
  void onInit() async {
    isThemeDark = brightness == Brightness.dark;
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    animation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, 100.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, 150.0, 0.0, 0.0),
    ).animate(_animationController!);

    groceries.value = await _localDatabase.returnGroceryItems();
    itemCount = await _localDatabase.getItemCount();
    super.onInit();
  }

  addNewItem(GroceryItem groceryItem) async{
    groceries.add(groceryItem);
    await _localDatabase.insertData(groceryItem);
    itemCount = itemCount! + 1;
    update();
  }
  updateItem(GroceryItem groceryItem) async{
    groceries[groceries.indexWhere((oldGroceryItem) => oldGroceryItem.id == groceryItem.id)] = groceryItem;
    await _localDatabase.update(groceryItem);
    update();
  }

  deleteItem(GroceryItem? groceryItem) async{
    groceries.removeWhere((oldGroceryItem) => oldGroceryItem.id == groceryItem!.id);
    await _localDatabase.delete(groceryItem!);
    itemCount = itemCount! - 1;
    update();
  }

  toggleTheme(newValue) {
    if (newValue) {
      isThemeDark = newValue;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      isThemeDark = newValue;
      Get.changeThemeMode(ThemeMode.light);
    }
    update();
  }

  List<GroceryItem> groceriesList(String? category) {
    return groceries
        .where((groceryItem) => groceryItem.category == category)
        .toList();
  }
}

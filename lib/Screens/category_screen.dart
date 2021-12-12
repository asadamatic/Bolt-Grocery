import 'package:boltgrocery/DataModels/category.dart';
import 'package:boltgrocery/DataModels/grocery_item.dart';
import 'package:boltgrocery/DesignElements/grocery_item_card.dart';
import 'package:boltgrocery/Screens/editing_screen.dart';
import 'package:boltgrocery/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final GroceryItem? groceryItem;
  final Category? category;
  CategoryScreen({this.groceryItem, this.category});


  //String to bool conversion
  bool getStatus(String value) {
    return value == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              '${category!.name}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: GetBuilder<GroceriesController>(builder: (_homeController) {
            final groceryItemList =
                _homeController.groceriesList(category!.slug);
            return Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: ListView.builder(
                itemCount: groceryItemList.length,
                itemBuilder: (context, index) {
                  return GroceryItemCard(
                    key: UniqueKey(),
                    groceryItem: groceryItemList[index],
                    category: category,
                  );
                },
              ),
            );
          }),
          bottomNavigationBar: Container(
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).bottomAppBarColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    label: Text(
                      'ADD NEW Item',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      Get.to(() => EditingScreen(
                            category: category,
                          ));
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}

import 'package:boltgrocery/DataModels/category.dart';
import 'package:boltgrocery/DataModels/grocery_item.dart';
import 'package:boltgrocery/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditingController extends GetxController {
  RxString? unit = 'Unit'.obs;
  List<String> dropDownValues = ['Unit', 'Kg', 'Litres', 'Dozen'];
  TextEditingController? itemNameController;
  TextEditingController? quantityEditingController;
  GroceriesController _groceriesController = Get.find();
  Category? category;
  GroceryItem? groceryItem;
  final formKey = GlobalKey<FormState>();

  EditingController({GroceryItem? paramGroceryItem, Category? paramCategory}) {
    if (paramGroceryItem != null){
      this.groceryItem = paramGroceryItem;
    }
    itemNameController = TextEditingController(text: paramGroceryItem?.name ?? '');
    quantityEditingController =
        TextEditingController(text: paramGroceryItem?.quantity ?? '');
    this.category = paramCategory;
    unit!.value = paramGroceryItem?.unit ?? 'Unit';
  }
  changeUnit(String? newValue) {
    unit!.value = newValue!;
  }

  editItem() {
    groceryItem!.name = itemNameController!.text;
    groceryItem!.quantity = quantityEditingController!.text;
    groceryItem!.unit = unit!.value;
    _groceriesController.updateItem(groceryItem!);
  }

  addItem() {
    _groceriesController.addNewItem(GroceryItem(
      id: _groceriesController.itemCount! + 1,
        time: DateTime.now(),
        name: itemNameController!.text,
        quantity: quantityEditingController!.text.trim(),
        unit: unit!.value,
        category: category!.slug,
        status: false));
  }

  submitForm() {
    if (formKey.currentState!.validate()) {
      if (groceryItem != null) {
        editItem();
      } else {
        addItem();
      }
      Get.back();
    }
  }

  String? textFieldValidator(String? value) {
    if (value!.isEmpty) {
      return 'Enter item quantity!';
    }
    return null;
  }

  chipSelection(int index){
    itemNameController!.text = category!.nameOptions![index];
  }
  @override
  void onInit() {
    super.onInit();
  }
}

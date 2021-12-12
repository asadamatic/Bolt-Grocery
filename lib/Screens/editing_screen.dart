import 'package:boltgrocery/DataModels/category.dart';
import 'package:boltgrocery/DataModels/grocery_item.dart';
import 'package:boltgrocery/controllers/editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditingScreen extends StatefulWidget {
  final GroceryItem? groceryItem;
  final Category? category;
  EditingScreen({this.groceryItem, this.category});

  @override
  State createState() {
    return EditingScreenState();
  }
}

class EditingScreenState extends State<EditingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              widget.groceryItem != null ? 'Edit Item' : 'Add Item',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: EditingForm(
            category: widget.category,
            groceryItem: widget.groceryItem,
          )),
    );
  }
}

class EditingForm extends StatelessWidget {
  EditingForm({GroceryItem? groceryItem, Category? category}) {
    _editingController = Get.put(
        EditingController(paramGroceryItem: groceryItem, paramCategory: category));
  }

  EditingController? _editingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _editingController!.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                13.0, 2.0, 13.0, 10.0),
                            child: TextFormField(
                              validator: _editingController!.textFieldValidator,
                              controller:
                                  _editingController!.itemNameController,
                              cursorColor: Colors.green[400],
                              autofocus: true,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Item Name',
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.green[400]!,
                                  width: 2,
                                )),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.green[400]!,
                                  width: 2,
                                )),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          ItemNameChips(editingController: _editingController)
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  13.0, 0.0, 13.0, 10.0),
                              child: TextFormField(
                                validator: _editingController!.textFieldValidator, // Only numbers can be entered,
                                controller: _editingController!
                                    .quantityEditingController,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.green[400],
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.green[400]!,
                                    width: 2,
                                  )),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.green[400]!,
                                    width: 2,
                                  )),
                                  hintText: 'Quantity',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child:
                          UnitDropDown(editingController: _editingController),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TextButton(
            child: Text('Save Changes'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: _editingController!.submitForm)
      ],
    );
  }
}

class ItemNameChips extends StatelessWidget {
  const ItemNameChips({
    Key? key,
    required EditingController? editingController,
  })  : _editingController = editingController,
        super(key: key);

  final EditingController? _editingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5.0),
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _editingController!.category!.nameOptions?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey[300]),
              child: InkWell(
                customBorder: RoundedRectangleBorder(),
                onTap: () => _editingController!.chipSelection(index),
                child: Text(_editingController!.category!.nameOptions![index]),
              ),
            );
          }),
    );
  }
}

class UnitDropDown extends StatelessWidget {
  const UnitDropDown({
    Key? key,
    required EditingController? editingController,
  })  : _editingController = editingController,
        super(key: key);

  final EditingController? _editingController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(13.0, 6.0, 13.0, 4.0),
            child: Obx(() {
              return DropdownButton<String>(
                underline: Container(
                  height: 2,
                  color: Colors.green[400],
                ),
                isExpanded: true,
                value: _editingController!.unit!.value,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: _editingController!.changeUnit,
                items: _editingController!.dropDownValues
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}

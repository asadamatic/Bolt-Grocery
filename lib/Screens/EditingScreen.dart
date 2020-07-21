import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DataModels/GroceryItem.dart';
import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class EditingScreen extends StatefulWidget{

  final GroceryItem groceryItem;
  final Category category;
  EditingScreen({this.groceryItem, this.category});

  @override
  State createState() {
    return EditingScreenState();
  }
}

class EditingScreenState extends State<EditingScreen>{

  //Text Editing Controller
  TextEditingController titleEditingController, quantityEditingController;
  final formKey = GlobalKey<FormState>();

  //Dropdown menu
  String unit = 'None';
  List<Category> categories = [
    Category(name: 'Beverages', slug: 'beverages', image: 'Firstimage'),
    Category(name: 'Vegetables', slug: 'vegetables', image: 'Firstimage'),
    Category(name: 'Dairy', slug: 'dairy', image: 'Firstimage'),
    Category(name: 'Frozen Foods', slug: 'frozenfoods', image: 'Firstimage'),
    Category(name: 'Meat', slug: 'meat', image: 'Firstimage'),
    Category(name: 'Personal Care', slug: 'personalcare', image: 'Firstimage'),];

  @override
  void initState() {
    super.initState();
    unit = widget.groceryItem == null ? unit : widget.groceryItem.unit;
    titleEditingController = TextEditingController(text: widget.category == null ? widget.groceryItem.name : '' );
    quantityEditingController = TextEditingController(text: widget.category == null ? widget.groceryItem.quantity : '' );
  }
  @override
  void dispose() {
    titleEditingController.dispose();
    quantityEditingController.dispose();
    super.dispose();
  }
  void addItem() async{

    GroceryItem newGroceryItem = GroceryItem(time: DateTime.now(), name: titleEditingController.text.trim(), quantity: quantityEditingController.text.trim(), unit: unit, category: widget.category.slug, status: false);
    await Provider.of<LocalDatabase>(context, listen: false).insertData(newGroceryItem);
    Navigator.of(context).pop();
  }
  void editItem() async{

    setState(() {
      widget.groceryItem.name = titleEditingController.text;
      widget.groceryItem.quantity = quantityEditingController.text;
      widget.groceryItem.unit = unit;
    });
    await Provider.of<LocalDatabase>(context, listen: false).update(widget.groceryItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(widget.category == null ?'Edit Item': 'Add Item', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          validator: (value){

                            if (value.isEmpty){

                              return 'Enter your item name!';
                            }
                            return null;
                          },
                          autofocus: true,
                          controller: titleEditingController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Item Name',
                              labelText: 'Item Name',
                              border: OutlineInputBorder()
                          ),
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
                            Container(

                              child: TextFormField(
                                validator: (value){

                                  if (value.isEmpty){

                                    return 'Enter item quantity!';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered,
                                controller: quantityEditingController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: 'Quantity',
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder()
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Unit', style: TextStyle(fontSize: 16.0),),
                            Container(
                              margin: EdgeInsets.only(top: 10.0,),
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey[500], width: 1.0, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: unit,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      unit = newValue;
                                    });
                                  },
                                  items: <String>['None','Kg', 'Litres', 'Dozen']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          FlatButton(
            child: Text('Save Changes'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:(){
              if(formKey.currentState.validate()){

                if (widget.category == null){
                    editItem();

                }else{
                  addItem();
                }
              }
            }
          )
        ],
      ),
    );
  }
}






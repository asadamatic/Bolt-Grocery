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

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.color,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(widget.groceryItem != null ?'Edit Item': 'Add Item', style: TextStyle(color: Colors.white),),
          ),
          body: EditingForm(category: widget.category, groceryItem: widget.groceryItem,)
      ),
    );
  }
}


class EditingForm extends StatefulWidget {

  final GroceryItem groceryItem;
  final Category category;
  EditingForm({this.groceryItem, this.category});

  @override
  _EditingFormState createState() => _EditingFormState();
}

class _EditingFormState extends State<EditingForm> {

  //Text Editing Controller
  TextEditingController itemNameController, quantityEditingController;
  final formKey = GlobalKey<FormState>();

  String unit = 'Unit';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unit = widget.groceryItem == null ? unit : widget.groceryItem.unit;
    itemNameController = TextEditingController(text: widget.groceryItem != null ? widget.groceryItem.name : '' );
    quantityEditingController = TextEditingController(text: widget.groceryItem != null ? widget.groceryItem.quantity : '' );
  }


  void addItem() async{

    GroceryItem newGroceryItem = GroceryItem(time: DateTime.now(), name: itemNameController.text, quantity: quantityEditingController.text.trim(), unit: unit, category: widget.category.slug, status: false);
    await Provider.of<LocalDatabase>(context, listen: false).insertData(newGroceryItem);
    Navigator.of(context).pop();
  }
  void editItem() async{

    setState(() {
      widget.groceryItem.name = itemNameController.text;
      widget.groceryItem.quantity = quantityEditingController.text;
      widget.groceryItem.unit = unit;
    });
    await Provider.of<LocalDatabase>(context, listen: false).update(widget.groceryItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 10.0),
                            child: TextFormField(
                                  validator: (value){

                                    if (value.isEmpty){
                                      return 'Enter item name!';
                                    }
                                    return null;
                                  },
                                  controller: itemNameController,
                                  cursorColor: Colors.green[400],
                                  autofocus: true,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Item Name',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green[400],
                                        width: 2,
                                      )
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green[400],
                                          width: 2,
                                        )
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 5.0),
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.category.nameOptions?.length ?? 0,
                                itemBuilder: (context, index){

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      selected: false,
                                      onSelected: (value){
                                          itemNameController.text = widget.category.nameOptions[index];
                                      },
                                      label: Text('${widget.category.nameOptions[index]}'),
                                    ),
                                  );
                                }),
                          )
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
                              padding: const EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 10.0),
                              child: TextFormField(
                                validator: (value){

                                  if (value.isEmpty){

                                    return 'Enter item quantity!';
                                  }
                                  return null;
                                }, // Only numbers can be entered,
                                controller: quantityEditingController,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.green[400],
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green[400],
                                          width: 2,
                                        )
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green[400],
                                          width: 2,
                                        )
                                    ),
                                    hintText: 'Quantity',
                                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                            elevation: 5.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(13.0, 6.0, 13.0, 4.0),
                                  child: DropdownButton<String>(
                                    underline: Container(
                                      height: 2,
                                      color: Colors.green[400],
                                    ),
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
                                    items: <String>['Unit','Kg', 'Litres', 'Dozen']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
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
            color: Theme.of(context).buttonColor,
            textColor: Colors.white,
            onPressed:(){
              if(formKey.currentState.validate()){

                if (widget.groceryItem != null){
                  editItem();

                }else{
                  addItem();
                }
              }
            }
        )
      ],
    );
  }

  @override
  void dispose() {
    quantityEditingController.dispose();
    super.dispose();
  }
}






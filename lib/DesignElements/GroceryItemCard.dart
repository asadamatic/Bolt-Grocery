import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DataModels/GroceryItem.dart';
import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:boltgrocery/Screens/EditingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroceryItemCard extends StatefulWidget{

  final GroceryItem groceryItem;
  final Category category;
  final Key key;
  GroceryItemCard({this.key, this.groceryItem, this.category});

  @override
  State createState() {
    return GroceryItemCardState();
  }
}

class GroceryItemCardState extends State<GroceryItemCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.fromLTRB(12.0, 2.5, 12.0, 2.5),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: widget.groceryItem.status,
            onChanged: (newValue) async {
              setState(() {
                widget.groceryItem.status = newValue;
              });
              await Provider.of<LocalDatabase>(context, listen: false).update(
                  widget.groceryItem);
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
                  child: Text(
                    '${widget.groceryItem.name}', overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(child: Text('${widget.groceryItem.quantity} ',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2),),
                      Flexible(child: Text(
                        widget.groceryItem.unit == 'Unit' || widget.groceryItem.unit == 'None' ? '' : '${widget
                            .groceryItem.unit}', overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ),
            onSelected: popupCallback,
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  void popupCallback(String value) async{
    switch (value) {
      case 'Edit':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditingScreen(
              groceryItem: widget.groceryItem,
              category: widget.category,)));

        break;

      case 'Delete':
        await Provider.of<LocalDatabase>(context, listen: false)
            .delete(widget.groceryItem);
        break;
    }
  }
}
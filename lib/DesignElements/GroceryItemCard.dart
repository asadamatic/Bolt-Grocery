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

class GroceryItemCardState extends State<GroceryItemCard> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 2.5),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: CheckboxListTile(
        value: widget.groceryItem.status,
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text('${widget.groceryItem.name}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.0, height: 1, color: Colors.black, fontFamily: 'Segoe', fontWeight: FontWeight.w400, letterSpacing: .8),)),
            IconButton(
              color: Colors.blueGrey,
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen(groceryItem: widget.groceryItem,)));
              },
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('${widget.groceryItem.quantity} ', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'Segoe', letterSpacing: 0.8),)),
                  Expanded(child: Text(widget.groceryItem.unit == 'None' ? '': '${widget.groceryItem.unit}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500, letterSpacing: .9),)),
                ],
              ),
            ),
            IconButton(
              color: Colors.blueGrey,
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () async{
                await Provider.of<LocalDatabase>(context, listen: false).delete(widget.groceryItem);

              },
            ),
          ],
        ),
        onChanged: (newValue) async{
          setState(() {
            widget.groceryItem.status = newValue;
          });
          await Provider.of<LocalDatabase>(context, listen: false).update(widget.groceryItem);
        },
      ),
    );
  }
}
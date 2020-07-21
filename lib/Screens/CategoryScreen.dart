import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DataModels/GroceryItem.dart';
import 'package:boltgrocery/DesignElements/GroceryItemCard.dart';
import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:boltgrocery/Screens/EditingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget{

  final GroceryItem groceryItem;
  final Category category;
  CategoryScreen({this.groceryItem, this.category});

  @override
  State createState() {
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen>{

  List<GroceryItem> groceryItems = List();

  //String to bool conversion
  bool getStatus(String value) {

    return value == 'true' ? true : false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('${widget.category.name}', style: TextStyle(color: Colors.white),),
        ),
      body: Consumer<LocalDatabase>(
        builder: (context, taskData, child){
          return FutureBuilder<List<GroceryItem>>(
              future: taskData.returnGroceryItems(widget.category.slug),
              builder: (context, snapshot) {

                if (snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return GroceryItemCard(key: UniqueKey(), groceryItem: snapshot.data[index], category: widget.category,);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              }
          );
        },
      ),
        floatingActionButton: Builder(
          builder: (BuildContext newContext){
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
              ),
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen(category: widget.category,)));
              },
            );
          },
        )
      ),
    );
  }
}


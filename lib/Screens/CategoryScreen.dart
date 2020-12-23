import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DataModels/GroceryItem.dart';
import 'package:boltgrocery/DesignElements/GroceryItemCard.dart';
import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:boltgrocery/Screens/EditingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  
  //String to bool conversion
  bool getStatus(String value) {

    return value == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.color,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
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
                  if (snapshot.data.length == 0){

                    return Center(child: Text("You don't have any items to show"),);
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return GroceryItemCard(key: UniqueKey(), groceryItem: snapshot.data[index], category: widget.category,);
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }
          );
        },
      ),
          bottomNavigationBar: Container(
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child:  RaisedButton(
                    color: Theme.of(context).bottomAppBarColor,
                    textColor: Colors.white,
                    child: Text('ADD NEW TASK', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    onPressed: () async{
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen(category: widget.category,)));

                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}


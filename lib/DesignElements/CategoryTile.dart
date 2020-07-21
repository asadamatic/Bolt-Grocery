import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/Screens/CategoryScreen.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget{

  Category category;
  CategoryTile({this.category});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        elevation: 5.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Image(
                  height: 50.0,
                  image: AssetImage(widget.category.image),
                ),
              ),
              Container(
                child: Text('${widget.category.name}', style: TextStyle(fontSize: 16.0),),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryScreen(category: widget.category,)));
      },
    );
  }
}

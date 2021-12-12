import 'package:boltgrocery/DataModels/category.dart';
import 'package:boltgrocery/Screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryTile extends StatefulWidget {
  final Category? category;
  CategoryTile({this.category});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.fromLTRB(16.5, 10.0, 10.0, 16.5),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width * .2,
                image: AssetImage(widget.category!.image!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '${widget.category!.name}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Get.to(() => CategoryScreen(
              category: widget.category,
            ));
      },
    );
  }
}

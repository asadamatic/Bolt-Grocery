import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:boltgrocery/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocalDatabase>(
      create: (context) => LocalDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        title: 'Bolt Grocery',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Color(0xff23b550),
        ),
        home: Wrapper(),
        ),
      );
  }
}

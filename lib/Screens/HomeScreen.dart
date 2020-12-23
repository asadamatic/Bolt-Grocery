import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DesignElements/CategoryTile.dart';
import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key,}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  List<Category> categories = [
    Category(name: 'Beverages', slug: 'beverages', image: 'Assets/beverages.png', nameOptions: ['Water', 'Coca-Cola', 'Orange Juice', 'Coffee', 'Tea', 'Lemonade', 'Apple Juice', 'Pepsi']),
    Category(name: 'Vegetables & Fruits', slug: 'vegetables', image: 'Assets/vegetables.png', nameOptions: ['Carrots', 'Bananas', 'Tomatoes', 'Lettuce', 'Apples', 'Potatoes', 'Strawberries', 'Onions', 'Oranges', 'Cucumbers', 'Mangoes', 'Grapes', 'Watermelon', 'Garlic']),
    Category(name: 'Dairy', slug: 'dairy', image: 'Assets/dairy.png', nameOptions: ['Bread', 'Milk', 'Eggs', 'Cookies', 'cake']),
    Category(name: 'Frozen Foods & Seafood', slug: 'frozenfoods', image: 'Assets/frozenfoods.png', nameOptions: ['Fish Fillet', 'Ice Cream', 'Nuggets', 'Burger Patties', 'French Fries', 'Frozen Peas', 'Chicken Fillet']),
    Category(name: 'Meat', slug: 'meat', image: 'Assets/meat.png', nameOptions: ['Fish', 'Chicken', 'Beef Boneless', 'Chicken Boneless', 'Beef', 'Mutton']),
    Category(name: 'Personal Care', slug: 'personalcare', image: 'Assets/personalcare.png', nameOptions: ['Soap', 'Toothpaste', 'Shampoo', 'Hair Conditioners', 'Toothbrush', 'Deodorant', 'Hair Gel', 'Mouthwash', 'Toothbrush', 'Tissue', 'Perfume'])];


  //Animation Conteollers
  AnimationController animationController;
  Animation<RelativeRect> animation;

  @override
  void initState() {
    super.initState();
    Provider.of<LocalDatabase>(context, listen: false).initializeDB();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    animation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, 80.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, 120.0, 0.0, 0.0),
    ).animate(animationController);

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 200.0,
                color: Theme.of(context).primaryColor,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Grocery List', style: TextStyle(fontSize: 36.0, color: Colors.white, fontWeight: FontWeight.bold),),
                        SizedBox(width: 10.0,),
                        Image(
                          height: 55.0,
                          image: AssetImage('Assets/homeicon.png'),
                        ),
                      ],
                    ),
                  )
              ),
              Container(),
              PositionedTransition(
                rect: animation,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ),
                  duration: Duration(milliseconds: 500),
                  builder: (context, opacity, child){

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opacity,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: categories.map((category) => CategoryTile(category: category,)).toList(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                    ),
                    onPressed: (){
                      showAboutDialog(context: context,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('App Icons by ', style: TextStyle(color: Colors.grey),),
                              GestureDetector(
                                  onTap: () async{
                                    await launch('https://flaticon.com');
                                  },
                                  child: Text('Flaticon.com', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey),)
                              ),
                            ],
                          )
                        ],
                        applicationName: 'Bolt Grocery',
                        applicationVersion: '1.0.3',
                        applicationIcon: Image(
                          image: AssetImage('Assets/icon.png'),
                          height: 60.0,
                          width: 60.0,
                        ),
                      );
                    },
                  ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Consumer<ValueNotifier<bool>>(
                  builder: (context, data, child){

                    return Transform.scale(
                      scale: .5,
                      child: DayNightSwitch(
                        value: data.value,
                        onChanged: (value){
                          Provider.of<ValueNotifier<bool>>(context, listen: false).value = value;
                          ThemeProvider.controllerOf(context).nextTheme();
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


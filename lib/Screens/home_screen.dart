import 'package:boltgrocery/DesignElements/category_tile.dart';
import 'package:boltgrocery/controllers/home_controller.dart';
import 'package:boltgrocery/values.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  final GroceriesController _groceriesController = Get.put(GroceriesController());
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
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 70.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Grocery List',
                          style: TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Image(
                          height: 55.0,
                          image: AssetImage('Assets/homeicon.png'),
                        ),
                      ],
                    ),
                  )),
              Container(),
              PositionedTransition(
                rect: _groceriesController.animation!,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ),
                  duration: Duration(milliseconds: 500),
                  builder: (context, dynamic opacity, child) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opacity,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: categories
                            .map((category) => CategoryTile(
                                  category: category,
                                ))
                            .toList(),
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
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'App Icons by ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await launch('https://flaticon.com');
                                },
                                child: Text(
                                  'Flaticon.com',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey),
                                )),
                          ],
                        )
                      ],
                      applicationName: 'Bolt Grocery',
                      applicationVersion: '1.0.4',
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
                  child: Transform.scale(
                      scale: .7,
                      child: GetBuilder<GroceriesController>(
                        builder: (_groceriesController) => DayNightSwitcher(
                          isDarkModeEnabled: _groceriesController.isThemeDark,
                          onStateChanged: _groceriesController.toggleTheme,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

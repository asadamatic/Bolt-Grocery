import 'package:boltgrocery/LocalDatabase/LocalDatabase.dart';
import 'package:boltgrocery/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<bool>>.value(
          value: ValueNotifier<bool>(false),
          builder: (context, widget){

            return ThemeProvider(
              saveThemesOnChange: true,
              themes: [
                AppTheme(
                  description: 'Light theme for app',
                  id: 'custom_light_theme',
                  data: ThemeData(
                    primaryColor: Colors.green[400],
                    accentColor: Colors.greenAccent,
                    textSelectionColor: Colors.green[400],
                    textSelectionHandleColor: Colors.green[400],
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    brightness: Brightness.light,
                    cursorColor: Colors.green[400],
                    appBarTheme: AppBarTheme(
                      color: Colors.green[400],
                    ),
                    buttonColor: Colors.green[400],
                    scaffoldBackgroundColor: Colors.white,
                    textTheme: TextTheme(
                      headline6: TextStyle(
                        color: Colors.black,
                          letterSpacing: 0.8,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                      ),
                      subtitle2: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.8,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      )
                    ),
                    bottomAppBarColor: Colors.green[400],
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    )
                  ),
                ),
                AppTheme(
                  description: 'Dark theme for app',
                  id: 'custom_dark_theme',
                  data: ThemeData(
                    textSelectionColor: Colors.green[400],
                    textSelectionHandleColor: Colors.green[400],
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    brightness: Brightness.dark,
                    cursorColor: Colors.green[400],
                    appBarTheme: AppBarTheme(
                      color: Colors.grey[900],
                      brightness: Brightness.dark,
                    ),
                    scaffoldBackgroundColor: Colors.grey[900],
                    buttonColor: Colors.grey[700],
                    textTheme: TextTheme(
                        headline6: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.8,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        subtitle2: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.8,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        )
                    ),
                    bottomAppBarColor: Colors.grey[900],
                  ),
                ),
              ],
              onInitCallback: (controller, previouslySavedThemeFuture) async {
                // Do some other task here if you need to
                String savedTheme = await previouslySavedThemeFuture;
                if (savedTheme != null) {
                  controller.setTheme(savedTheme);
                  if (savedTheme == 'custom_dark_theme') {
                    Provider
                        .of<ValueNotifier<bool>>(context, listen: false)
                        .value = true;
                  }
                }
              },
              child: ChangeNotifierProvider<LocalDatabase>(
                create: (context) => LocalDatabase(),
                child: ThemeConsumer(
                    child: Builder(
                      builder: (themeContext) => MaterialApp(
                        debugShowCheckedModeBanner: false,
                        color: Colors.white,
                        title: 'Bolt Grocery',
                        theme: ThemeProvider.themeOf(themeContext).data,
                        home: Wrapper(),
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }
}

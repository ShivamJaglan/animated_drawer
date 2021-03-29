import 'package:flutter/material.dart';
import 'package:guitar_app/custom_drawer.dart';
import 'package:guitar_app/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    AppBar appBar = AppBar(
      title: Text('Fettle'),
      leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                CustomDrawer.of(appBarContext).toggle();
              },
              icon: Icon(Icons.menu)
          );
        },
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fettle',
      // theme: ThemeData(
      //   primarySwatch: Colors.black,
      // ),
      home: CustomDrawer(
        child: Home(appBar: appBar),
      ),
    );
  }
}
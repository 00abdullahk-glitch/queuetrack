import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar:BottomNavigationBar(
          currentIndex:currentTab,
          onTap: (value){
            setState(() {
              currentTab=value;
            });
          },
          items:[
        BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite),label:"fav"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label:"cart"),
      ]),
      body: IndexedStack(),
    );
  }
}


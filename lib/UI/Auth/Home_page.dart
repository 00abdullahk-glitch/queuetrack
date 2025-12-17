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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (value) {
          setState(() {
            currentTab = value;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "fav"),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "cart"),
        ],
      ),
      // Provide non-empty children so the IndexedStack has a defined layout
      body: IndexedStack(
        index: currentTab,
        children: const [
          Center(child: Text('Home content')),
          Center(child: Text('Favorites')),
          Center(child: Text('Cart')),
        ],
      ),
    );
  }
}


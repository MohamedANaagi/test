import 'package:flutter/material.dart';
import 'package:we_session1/e-commerce_application/screens/cart_screen/cart_screen.dart';
import 'package:we_session1/e-commerce_application/screens/categories/categories_screen.dart';
//import 'categories_screen/categories_screen.dart';  // Import the CategoriesScreen

import '../favourite_screen/favourite_screen.dart';
import '../home_screen.dart';
import '../profile_screen/profile_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIdx = 0;

  void _navigateToCategory(int index) {
    setState(() {
      currentIdx = index;
    });
  }

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(),
      CategoriesScreen(onCategoryTap: _navigateToCategory), // Pass the callback
      CartScreen(), // You can update this with a CartScreen later
      FavouriteScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        onTap: (value) {
          setState(() {
            currentIdx = value;
          });
        },
        currentIndex: currentIdx,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: screens[currentIdx],
    );
  }
}


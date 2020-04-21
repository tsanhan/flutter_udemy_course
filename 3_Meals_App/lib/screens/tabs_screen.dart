import '../models/meal.dart';

import '../widgets/main_drawer.dart';
import './favorites_screen.dart';
import './categories_screen.dart';

import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
Set<Meal> favoritesMeals;
TabsScreen(this.favoritesMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  
  List<Map<String,Object>> _pages;

  
  @override
  void initState(){
      _pages = [
      {
        'page': CategoriesScreen(),
        'title': 'Categories' 
      },
      {
        'page': FavoritesScreen(widget.favoritesMeals),
        'title': 'Your Favorites'
      }
    ];

    super.initState();
  }


  
  
  int _selectedPageIndex = 0;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          drawer: MainDrawer(),
          appBar: AppBar(
            title: Text(_pages[_selectedPageIndex]['title']),
          ),
          body: _pages[_selectedPageIndex]['page'],
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            selectedItemColor: Theme.of(context).accentColor,
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.shifting, // to add little animation
            items: [
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor, // needed because we added 'type'
                icon: Icon(Icons.category),
                title: Text('Categories')),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.star),
                title: Text('Favorites'))
            ]
          ),

      );

    // for tabs on top - no need for statefullness
    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //       appBar: AppBar(
    //         title: Text('Meals'),
    //         bottom: TabBar(tabs: <Widget>[
    //           Tab(
    //             icon: Icon(Icons.category),
    //             text: 'Categories',
    //           ),
    //           Tab(
    //             icon: Icon(Icons.star),
    //             text: 'Favorits',
    //           )
    //         ],
    //         ),
    //       ),
    //       body: TabBarView(
    //         children: <Widget>[
    //           CategoriesScreen(),
    //           FavoritesScreen()
    //         ],
    //         ),
    //     ),
    //   );
  }
}
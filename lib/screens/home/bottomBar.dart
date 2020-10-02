import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/category.dart';

class BottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

List<BottomNavigationBarItem> bottomNavItems =
    new List<BottomNavigationBarItem>();
List<BottomNavigationBarItem> placeHolderBottomNavItems = [
  BottomNavigationBarItem(
      icon: Icon(Icons.video_library), title: Text("Movies")),
  BottomNavigationBarItem(
      icon: Icon(Icons.library_music), title: Text("Music")),
  BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("Books"))
];

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: getCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            addItems(snapshot.data.items);
            return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  items: bottomNavItems,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.purpleAccent,
                  unselectedItemColor: Colors.white54,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.black,
                ));
          } else if (snapshot.hasError) {
            // handle error.
            return Container(child: Text("Error"));
          } else {
            return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  items: placeHolderBottomNavItems,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.purpleAccent,
                  unselectedItemColor: Colors.white54,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.black,
                ));
          }
        });
  }

  addItems(List<Item> items) {
    if (bottomNavItems != null) bottomNavItems.clear();
    items.forEach((Item item) {
      bottomNavItems.add(BottomNavigationBarItem(
          icon: Icon(Icons.video_library), title: Text(item.name)));
    });
  }
}

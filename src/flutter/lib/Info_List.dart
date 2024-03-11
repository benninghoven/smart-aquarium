import 'package:flutter/material.dart';

enum Tab { house, message, person, car, trash }

class MyTabBar extends StatelessWidget {
  final Tab selectedTab;
  final Function(Tab) onTabChanged;

  const MyTabBar({super.key, required this.selectedTab, required this.onTabChanged});

  String _getFillImage(Tab tab) {
    return '${tab.toString().split('.').last}.fill';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Tab.values.map((tab) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onTabChanged(tab);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    (selectedTab == tab ? Icons.home : _getFillImage(tab)) as IconData?,
                    size: selectedTab == tab ? 30 : 22,
                    color: selectedTab == tab ? Colors.red : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MyTabBar_Previews extends StatelessWidget {
  final Tab selectedTab;

  const MyTabBar_Previews({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyTabBar(selectedTab: selectedTab, onTabChanged: (tab) {}),
      ),
    );
  }
}

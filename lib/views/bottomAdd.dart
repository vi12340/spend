import 'package:spend/views/category.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class bottomAdd extends StatefulWidget {
  const bottomAdd({super.key});

  @override
  State<bottomAdd> createState() => _bottomAddState();
}

class _bottomAddState extends State<bottomAdd> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Add'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => category()));
                     
                    },
                    icon: Icon(Icons.settings)),
                bottom: TabBar(tabs: [
                  Tab(text: 'Revenue'),
                  Tab(text: 'Expaditure'),
                ])),
            body: TabBarView(children: [
              ListView.builder(
                  itemCount: listcategory.length,
                  itemBuilder: (context, index) {
                    final item = listcategory[index];
                    return Container(
                      child: CategoryLine(item.icon, item.name),
                    );
                  }),
              ListView.builder(
                  itemCount: listcategory.length,
                  itemBuilder: (context, index) {
                    final item = listcategory[index];
                    return Container(
                      child: CategoryLine(item.icon, item.name),
                    );
                  }),
            ])));
  }
}

class categoryL {
  Icon icon;
  String name;
  categoryL(this.icon, this.name);
}

List<categoryL> listcategory = [
  categoryL(
      Icon(
        MdiIcons.lipstick,
        color: Colors.white,
      ),
      'a'),
  categoryL(
      Icon(
        MdiIcons.lipstick,
        color: Colors.white,
      ),
      'a'),
];

import 'package:flutter/material.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/views/categoryAdd.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spend/views/icons.dart';

class category extends StatefulWidget {
  const category({super.key});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  DbHelper? dbHelper;
  late Future<List<categoryModel>> listCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    listCategory = dbHelper!.getCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phân loại'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => categoryAdd() ));
                },
                icon: Icon(Icons.edit_calendar_outlined))
          ],
        ),
        body: FutureBuilder(
          future: listCategory,
          builder: (context, snapshot){
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                final item = snapshot.data![index];
                    return Card(
                        child: ListTile(
                          title: Text(item.name),
                      ),
                    );
                }
            );
          },
        )
    );
  }
}
Widget CategoryLine(Icon icon, String name) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(15),
        child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(50)),
            child: icon),
      ),
      Text(name),
    ],
  );
}

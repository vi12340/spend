import 'package:flutter/material.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/views/categoryAdd.dart';

class category extends StatefulWidget {
  const category({super.key});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  DbHelper? dbHelper;
  late Future<List<categoryModel>> listCategory;
  final controller = TextEditingController();

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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => categoryAdd()));
                },
                icon: Icon(Icons.edit_calendar_outlined))
          ],
        ),
        body: FutureBuilder(
          future: listCategory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          width: 50,
                          color: Colors.red,
                        child: const Icon(Icons.delete_outline, color: Colors.white),),
                        key: ValueKey<int>(snapshot.data!.length),
                        confirmDismiss: (direction){
                          return showDialog(context: context,
                              builder: (contex){
                            return AlertDialog(
                              title: Text('Bạn chắc chắn muốn xoá ${item.name}?'),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text('CANCLE')),
                                TextButton(onPressed: (){
                                  setState(() {
                                    dbHelper!.deleteCategory(item.idCategory!);
                                    snapshot.data!.remove(item.idCategory);
                                    listCategory = dbHelper!.getCategory();
                                  });
                                  Navigator.pop(context);
                                }, child: Text('DELETE')),

                              ],
                            );
                              });
                        },

                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Color(int.parse(item.color)),
                                  borderRadius: BorderRadius.circular(50)
                              ),

                              child: Center(
                                child: SizedBox(
                                  width: 35,
                                  child: Image.asset(item.icon, color: Colors.white),
                                ),
                              ),
                            ),
                            title: Text(item.name),
                          ),
                        ),

                      ),
                    );


                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
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

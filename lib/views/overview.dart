import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spend/config/textStyle.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/views/add.dart';
import 'package:spend/views/bottomBudget.dart';
import 'package:flutter/material.dart';
import 'package:spend/models/manageCategory.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class overview extends StatefulWidget {
  const overview({super.key});

  @override
  State<overview> createState() => _overviewState();
}

class _overviewState extends State<overview> {
  DbHelper? dbHelper;
  late Future<List<manageModel>> listManage;
  late Future<List<manageCategory>> listManageCategory;
  final controllerPrice = TextEditingController();
  final controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    listManage = dbHelper!.getManage();
    listManageCategory = dbHelper!.getManageCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: appBar(),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: (() {
                        setState(() {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    height: 100,
                                    child: bottomBudget(),
                                  ),
                                );
                              });
                        });
                      }),
                      child: const SizedBox(
                          child: Text('Đặt ngân sách',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                  ),
                  FutureBuilder(
                      future: dbHelper!.sumBudget(),
                      builder: (context, snapshot1) {
                        return FutureBuilder(
                            future: dbHelper!.sumSpend(),
                            builder: (context, snapshot2){
                              if(snapshot1.hasData && snapshot2.hasData){
                                if(snapshot1.data[0]['SUM(price)'] != null && snapshot2.data[0]['SUM(price)'] != null){
                                  int a = snapshot1.data[0]['SUM(price)'];
                                  int b = snapshot2.data[0]['SUM(price)'];
                                  int c = a-b;
                                  return Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: Text(
                                      c.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }else if(snapshot1.data[0]['SUM(price)'] == null && snapshot2.data[0]['SUM(price)'] != null){
                                  return  const Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: Text(
                                      '0',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }else if(snapshot1.data[0]['SUM(price)'] != null && snapshot2.data[0]['SUM(price)'] == null){
                                  return Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: Text(
                                        '${snapshot1.data[0]['SUM(price)']}', style: TextStyle(fontSize: 20)
                                    ),
                                  );
                                }
                                else{
                                  return  const Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: Text(
                                      '0',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }
                              }else
                                return CircularProgressIndicator();
                            }
                        );

                      }
                  )
                ],
              ),
              Container(
                  height: 600,
                  padding: EdgeInsets.only(top: 20),
                  child:  list()),
            ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 550,
                    child: SingleChildScrollView(
                      child: add(),
                    ),
                  );
                });
          });
        },
        child: Icon(Icons.add),
        mini: true,
      ),
    );
  }

  Widget appBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: dbHelper!.sumIncome(),
            builder: (context, snapshot1) {
              return FutureBuilder(
                  future: dbHelper!.sumSpend(),
                  builder: (context, snapshot2) {
                    if (snapshot1.hasData && snapshot2.hasData) {
                      if (snapshot1.data[0]['SUM(price)'] == null &&
                          snapshot2.data[0]['SUM(price)'] == null) {
                        return Text('0', style: TextStyle(fontSize: 25));
                      } else if (snapshot1.data[0]['SUM(price)'] != null &&
                          snapshot2.data[0]['SUM(price)'] == null) {
                        return Text('${snapshot1.data[0]['SUM(price)']}',
                            style: TextStyle(fontSize: 25));
                      }
                      else if (snapshot1.data[0]['SUM(price)'] == null &&
                          snapshot2.data[0]['SUM(price)'] != null) {
                        return Text('- '+'${snapshot2.data[0]['SUM(price)']}',
                            style: TextStyle(fontSize: 25));
                      }
                      else {
                        int a = snapshot1.data[0]['SUM(price)'];
                        int b = snapshot2.data[0]['SUM(price)'];
                        int c = a - b;
                        return Text(c.toString(),
                            style: TextStyle(fontSize: 25));
                      }
                    } else
                      return CircularProgressIndicator();
                  });
            }),
        FutureBuilder(
            future: dbHelper!.sumSpend(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot!.data[0]['SUM(price)'] != null) {
                  return Text('Chi tiêu: - ${snapshot!.data[0]['SUM(price)']}',
                      style: TextStyle(fontSize: 15));
                } else {
                  return Text('Chi tiêu: 0', style: TextStyle(fontSize: 15));
                }
              } else
                return CircularProgressIndicator();
            }),
        FutureBuilder(
            future: dbHelper!.sumIncome(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data[0]['SUM(price)'] != null) {
                  return Text('Thu nhập: ${snapshot.data[0]['SUM(price)']}',
                      style: TextStyle(fontSize: 15));
                } else {
                  return Text('Thu nhập: 0', style: TextStyle(fontSize: 15));
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  Widget list(){
    return FutureBuilder(
        future: listManageCategory,
        builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          if(DateTime.parse(item.dateTime).month == DateTime.now().month && DateTime.parse(item.dateTime).year == DateTime.now().year ){
                            if(item.type == 'Thu'){
                              return
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title :Text(item.type),
                                            content: Text(item.name+'\n'+item.price.toString() +'\n' + DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime)) ),
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('CANCEL')),
                                              TextButton(onPressed: (){
                                                showDialog(context: context,
                                                    builder: (context){
                                                      return AlertDialog(
                                                        title: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(item.type),
                                                            Text(item.name)
                                                          ],
                                                        ),
                                                        content: Container(
                                                          height: 160,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextField(
                                                                controller: controllerPrice,
                                                                decoration: InputDecoration(
                                                                    hintText: item.price.toString()
                                                                ),
                                                                keyboardType: TextInputType.number,

                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 20),
                                                                child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime))),
                                                              ),
                                                              TextField(
                                                                controller: controllerComment,
                                                                decoration: InputDecoration(
                                                                    hintText: item.comment
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: (){
                                                                controllerPrice.clear();
                                                                controllerComment.clear();
                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text("CANCEL")),
                                                          TextButton(onPressed: (){
                                                            setState(() {
                                                              dbHelper!.updateManage(manageModel(id: item.id,idCategory: item.idCategory, price: int.parse(controllerPrice.text), type: item.type, dateTime: item.dateTime, comment: controllerComment.text));
                                                              listManage = dbHelper!.getManage();
                                                            });
                                                            controllerPrice.clear();
                                                            controllerComment.clear();
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                                          }, child: Text('SAVE'))
                                                        ],
                                                      );
                                                    });
                                              },
                                                  child: Text('EDIT'))
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(onPressed: (value){
                                            showDialog(
                                                context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                    title: Text('Bạn chắc chắn muốn xoá ${item.name}?', style: addtextStyle.textstyleOverView ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.pop(context);
                                                          }, child: Text('CANCLE')),
                                                      TextButton(
                                                          onPressed: (){
                                                            setState(() {
                                                              dbHelper!.deleteManage(item.id!);
                                                              snapshot.data!.remove(item.id);
                                                              listManageCategory = dbHelper!.getManageCategory();
                                                            });
                                                            Navigator.pop(context);
                                                          }, child: Text('DELETE')),
                                                    ],
                                                  );
                                                });
                                          },
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              width: double.infinity,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffCECECD),
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text('')),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime))),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Card(
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
                                              title: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(item.name),
                                              ),
                                              trailing: Text(item.price.toString()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            }else{
                              return
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title :Text(item.type),
                                            content: Text(item.name+'\n'+item.price.toString() +'\n' + DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime)) ),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                              },
                                                  child: Text('CANCEL')),
                                              TextButton(onPressed: (){
                                                showDialog(context: context,
                                                    builder: (context){
                                                      return AlertDialog(
                                                        title: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(item.type),
                                                            Text(item.name)
                                                          ],
                                                        ),
                                                        content: Container(
                                                          height: 160,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextField(
                                                                controller: controllerPrice,
                                                                decoration: InputDecoration(
                                                                    hintText: item.price.toString()
                                                                ),
                                                                keyboardType: TextInputType.number,

                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 20),
                                                                child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime))),
                                                              ),
                                                              TextField(
                                                                controller: controllerComment,
                                                                decoration: InputDecoration(
                                                                    hintText: item.comment
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(onPressed: (){
                                                            controllerPrice.clear();
                                                            controllerComment.clear();
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          }, child: Text('CANCEL')),
                                                          TextButton(onPressed: (){
                                                            dbHelper!.updateManage(manageModel(id: item.id,idCategory: item.idCategory, price: int.parse(controllerPrice.text), type: item.type, dateTime: item.dateTime, comment: controllerComment.text));
                                                            setState(() {
                                                              listManage = dbHelper!.getManage();
                                                            });
                                                            controllerPrice.clear();
                                                            controllerComment.clear();
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                                          }, child: Text('SAVE'))
                                                        ],
                                                      );
                                                    });
                                              },
                                                  child: Text('EDIT'))
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (value){
                                              showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    return AlertDialog(
                                                      title: Text('Bạn chắc chắn muốn xoá ${item.name}?', style: addtextStyle.textstyleOverView ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: (){
                                                              Navigator.pop(context);
                                                            }, child: Text('CANCLE')),
                                                        TextButton(
                                                            onPressed: (){
                                                            setState(() {
                                                              dbHelper!.deleteManage(item.id!);
                                                              snapshot.data!.remove(item.id);
                                                              listManageCategory = dbHelper!.getManageCategory();
                                                              });
                                                            Navigator.pop(context);
                                                            }, child: Text('DELETE')),
                                                      ],
                                                    );
                                                  });


                                          },
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              width: double.infinity,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffCECECD),
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text('')),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(item.dateTime))),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Card(
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
                                              title: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(item.name),
                                              ),
                                              trailing: Text('- '+item.price.toString(), style: TextStyle(color: Colors.red)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            }
                          }
                          else{
                            return Container();
                          }
                        }
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
  }}

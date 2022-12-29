import 'package:flutter/cupertino.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/views/add.dart';
import 'package:spend/views/bottomBudget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class overview extends StatefulWidget {
  const overview({super.key});

  @override
  State<overview> createState() => _overviewState();
}

class _overviewState extends State<overview> {
  DbHelper? dbHelper;
  late Future<List<manageModel>> listManage;
  final controllerPrice = TextEditingController();
  final controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    listManage = dbHelper!.getManage();
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
        child: ListView(children: [
          Column(children: [
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
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding:  EdgeInsets.only(top: 13),
                          child: Text('${snapshot!.data[0]['SUM(price)']}', style: TextStyle(fontSize: 20),),
                        );
                      } else {
                        return Text(
                          '0',style: TextStyle(fontSize: 20)
                        );
                      }
                    })
              ],
            ),
            Container(
              height: 500,
              padding: EdgeInsets.only(top: 20),
              child: list()
            ),
          ]),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 550,
                    child: add(),
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
          future: dbHelper!.sumSpend(),
            builder: (context, snapshot1){
              return FutureBuilder(
                future: dbHelper!.sumIncome(),
                  builder: (context, snapshot2){
                  if(snapshot1.hasData && snapshot2.hasData){
                    int a = snapshot2.data[0]['SUM(price)'];
                    int b = snapshot1.data[0]['SUM(price)'];
                    int c = a-b;
                    return Text(c.toString(), style: TextStyle(fontSize: 25));
                  }
                  else{
                    return Text(
                        '0', style: TextStyle(fontSize: 25)
                    );
                  }
                  });
            }),

        FutureBuilder(
            future: dbHelper!.sumSpend(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Chi tiêu: - ${snapshot!.data[0]['SUM(price)']}',
                    style: TextStyle(fontSize: 15));
              } else {
                return Text('Chi tiêu: 0', style: TextStyle(fontSize: 15));

              }
            }),
        FutureBuilder(
            future: dbHelper!.sumIncome(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Thu nhập: ${snapshot.data[0]['SUM(price)']}',
                    style: TextStyle(fontSize: 15));
              } else {
                return Text(
                    'Thu nhập: 0', style: TextStyle(fontSize: 15)
                );
              }
            }),
      ],
    );
  }

  Widget listExpenditures(String type, String price, String date) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: Text(type)),
        ),
        Expanded(child: Text(price)),
        Text(date)
      ]),
    );
  }

  Widget list(){
    return FutureBuilder(
        future: listManage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context){
                            return AlertDialog(
                              title :Text(item.type),
                              content: Text(item.price.toString() +'\n' + item.dateTime ),
                              actions: [
                                TextButton(onPressed: (){
                                  showDialog(context: context,
                                      builder: (context){
                                    return AlertDialog(
                                      title: Text(item.type),
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
                                              child: Text(item.dateTime),
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
                                          dbHelper!.updateManage(manageModel(idCategory: item.idCategory, price: int.parse(controllerPrice.text), type: item.type, dateTime: item.dateTime, comment: controllerComment.text));
                                          setState(() {
                                            listManage = dbHelper!.getManage();
                                          });
                                          controllerPrice.clear();
                                          controllerComment.clear();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }, child: Text('Save'))
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
                                  setState(() {
                                    dbHelper!.deleteManage(item.id!);
                                    snapshot.data?.remove(item.id);
                                    listManage = dbHelper!.getManage();
                                  });
                                },
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              child: ListTile(
                                leading: Text(item.type),
                                title: Text(item.price.toString()),
                                trailing: Text(item.dateTime),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
              );
          } else {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
        });

  }


}

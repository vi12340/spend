import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/views/add.dart';
import 'package:spend/views/bottomBudget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class overview extends StatefulWidget {
  const overview({super.key});

  @override
  State<overview> createState() => _overviewState();
}

class _overviewState extends State<overview> {
  DbHelper? dbHelper;
  late Future listManage;
  late Future listSpend;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    listManage = dbHelper!.getManage();
    listSpend = dbHelper!.sumSpend();
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
                        return Text(snapshot!.data.toString());
                      } else {
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
            Container(
              height: 500,
              padding: EdgeInsets.only(top: 20),
              child: FutureBuilder(
                  future: listManage,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Card(
                              child: ListTile(
                                leading: Text(item.type),
                                title: Text(item.price.toString()),
                                trailing: Text(item.dateTime),
                              ),
                            );
                          });
                    } else {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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
        Text(
          '0000',
          style: TextStyle(fontSize: 25),
        ),
        FutureBuilder(
            future: listSpend,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Chi tiêu: - ${snapshot!.data}',
                    style: TextStyle(fontSize: 15));
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        FutureBuilder(
            future: dbHelper!.sumIncome(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Thu nhập: ${snapshot.data}',
                    style: TextStyle(fontSize: 15));
              } else {
                return Container(
                  child: CircularProgressIndicator(),
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
}

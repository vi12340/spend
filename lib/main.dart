import 'package:spend/models/budget.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/views/category.dart';
import 'package:spend/views/chart.dart';
import 'package:spend/views/overview.dart';
import 'package:spend/models/db_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DbHelper? dbHelper;
  late Future<List<budgetModel>> listBudget;
  late Future<List<categoryModel>> listCategory;
  late Future<List<manageModel>> listManage;

  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }
  loadData() async{
    listBudget = dbHelper!.getBudget();
    listCategory = dbHelper!.getCategory();
    listManage = dbHelper!.getManage();
  }

  int _currenIndex = 0;
  final tabs = [overview(), category(), chart()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: tabs[_currenIndex],
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart), label: 'Chart'),
          ],
          currentIndex: _currenIndex,
          onTap: (index) {
            setState(() {
              _currenIndex = index;
            });
          },
        ),
      ),
    );
  }
}

Widget appBar() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        'Tổng: ',
        style: TextStyle(fontSize: 25),
      ),
      Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text('Chi tiêu: ', style: TextStyle(fontSize: 15)),
      ),
      Text('Thu nhập: ', style: TextStyle(fontSize: 15)),
    ],
  );
}
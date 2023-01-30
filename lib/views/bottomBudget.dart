import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spend/main.dart';
import 'package:spend/models/budget.dart';
import 'package:spend/models/db_helper.dart';


class bottomBudget extends StatefulWidget {
  const bottomBudget({super.key});

  @override
  State<bottomBudget> createState() => _bottomBudgetState();
}

class _bottomBudgetState extends State<bottomBudget> {
  DbHelper? dbHelper;
  late Future<List<budgetModel>> listBudget;
  final controller = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    listBudget = dbHelper!.getBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                dbHelper!.insertBudget(budgetModel(
                    price: int.parse(controller.text),
                    dateTime: DateFormat('yyyy-MM-dd').format(date)));
                setState(() {
                  listBudget = dbHelper!.getBudget();
                });
                Navigator.push(context, MaterialPageRoute(builder: (contex)=> MyApp()));
              },
              child: const Text('Save')),
        ],
      ),
    );
  }
}

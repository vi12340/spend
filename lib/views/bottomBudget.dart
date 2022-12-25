import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spend/models/budget.dart';
import 'package:spend/models/db_helper.dart';
import 'package:intl/intl.dart';

class bottomBudget extends StatefulWidget {
  const bottomBudget({super.key});

  @override
  State<bottomBudget> createState() => _bottomBudgetState();
}

class _bottomBudgetState extends State<bottomBudget> {
  DbHelper? dbHelper;
  late Future<List<budgetModel>> listBudget;
  final controller = TextEditingController();

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
                Navigator.pop(context);
                dbHelper!.insertBudget(budgetModel(
                    price: int.parse(controller.text),
                    dateTime: DateFormat("yyyy-MM-dd hh:mm:ss")
                        .format(DateTime.now())));
              },
              child: const Text('Save')),
        ],

        // Expanded(
        //   child: FutureBuilder(
        //       future: listBudget,
        //       builder: (context, AsyncSnapshot<List<budgetModel>> snapshot){
        //         return ListView.builder(
        //             itemCount: snapshot.data?.length,
        //             itemBuilder: (context, index){
        //               return Container(
        //                 child: Card(
        //                   child: ListTile(
        //                     leading: Text(snapshot.data![index].price.toString()),
        //                     trailing: Text(snapshot.data![index].dateTime.toString()),
        //                   ),
        //                 ),
        //               );
        //             }
        //         );
        //       }),
        // ),
      ),
    );
  }
}

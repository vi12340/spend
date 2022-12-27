import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/views/chartLine.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

class chart extends StatefulWidget {
  const chart({super.key});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  DbHelper? dbHelper;
  late Future<List<manageModel>> listManage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    listManage = dbHelper!.getManage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => chartLine()));
                },
                icon: Icon(MdiIcons.chartLine))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [piechar()],
          ),
        ));
  }
  Widget piechar() {
    return Column(children: [
      PieChart(dataMap: data),

    ]);
  }
}

Map<String, double> data = {
  'a': 3, 'b': 5, 'c': 6
};



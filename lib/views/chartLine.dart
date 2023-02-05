import 'package:spend/config/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spend/models/db_helper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class chartLine extends StatefulWidget {
  const chartLine({super.key});

  @override
  State<chartLine> createState() => _chartLineState();
}

class _chartLineState extends State<chartLine> {
  DateTime date = DateTime.now();
  DbHelper? dbHelper;
  List<FlSpot> listIncome = [];
  List<FlSpot> listSpend = [];
  List<int> monthFull = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> monthFull2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          onPressed: () {},
                          child: Text(
                            '${date.year}',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 350,
                  padding: EdgeInsets.only(top: 10),
                      child: incomeSpend(),

                    ),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  width: 150,
                  child: table()
                 ),
            ],
          ),
        ));
  }
  Widget incomeSpend(){
    return FutureBuilder(
        future: dbHelper!.sumIncomeMonth(),
        builder: (contex, snapshot) {
    return FutureBuilder(
    future: dbHelper!.sumSpendMonth(),
    builder: (contex, snapshot2) {
      if (snapshot.hasData & snapshot2.hasData) {
        List<int> month = [];
        List<int> month2 = [];

        void check1(){

          for (int i = 0; i < snapshot.data.length; i++) {
            FlSpot fl = FlSpot(double.parse(snapshot.data[i]['month']),
                snapshot.data[i]['SUM(price)'].toDouble());
            listIncome.add(fl);
            month.add(int.parse(snapshot.data[i]['month']));
          }


          for (int i = 0; i < monthFull.length; i++) {
            for (int j = 0; j < month.length; j++) {
              if (monthFull[i] == month[j]) {
                monthFull.remove(monthFull[i]);
              }
            }

          }

          for (int i = 0; i < monthFull.length; i++) {
            FlSpot fl = FlSpot(monthFull[i].toDouble(), 0);
            listIncome.insert(monthFull[i] - 1, fl);
          }

        }

        void check2(){

            for (int i = 0; i < snapshot2.data.length; i++) {
              FlSpot fl = FlSpot(double.parse(snapshot2.data[i]['month']),
                  snapshot2.data[i]['SUM(price)'].toDouble());
              listSpend.add(fl);
              month2.add(int.parse(snapshot2.data[i]['month']));
            }


            for (int i = 0; i < monthFull2.length; i++) {
              for (int j = 0; j < month2.length; j++) {
                if (monthFull2[i] == month2[j]) {
                  monthFull2.remove(monthFull2[i]);
                }
              }

          }

            for (int i = 0; i < monthFull2.length; i++) {
              FlSpot fl = FlSpot(monthFull2[i].toDouble(), 0);
              listSpend.insert(monthFull2[i] - 1, fl);
            }

        }


        print(listIncome);
        print(listSpend);


        check1();
        check2();

        return lineChart();
      } else {
        return Center(child: CircularProgressIndicator());
      }

          });
    });
    }

  Widget lineChart() {
    return LineChart(
        LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
      LineChartBarData(
        spots: listIncome,
        colors: [Colors.green],
        isCurved: true,
      ),
      LineChartBarData(
        spots: listSpend,
        colors: [Colors.red],
        isCurved: true,
      )
    ]));
  }

  Widget table(){
    return FutureBuilder(
      future: dbHelper!.sumIncomeMonth(),
        builder: (context, snapshot){
          future: dbHelper!.sumSpendMonth(),        return FutureBuilder(
              builder: (context, snapshot2){
                return DataTable(columns: [
                  DataColumn(
                      label: Text('Month', style: addtextStyle.textstyle)),
                  DataColumn(
                      label: Text('Revenue', style: addtextStyle.textstyle)),
                  DataColumn(
                      label:
                      Text('Expaditure', style: addtextStyle.textstyle)),
                  DataColumn(
                      label: Text('Risk', style: addtextStyle.textstyle)),
                ], rows: [
                  DataRow(cells: [
                    DataCell(Text('1')),
                    DataCell(Text('3')),
                    DataCell(Text('100')),
                    DataCell(Text('100')),
                  ])
                ]);
              });
        });

  }
}
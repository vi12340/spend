import 'package:spend/config/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class chartLine extends StatefulWidget {
  const chartLine({super.key});

  @override
  State<chartLine> createState() => _chartLineState();
}

class _chartLineState extends State<chartLine> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                height: 300,
                padding: EdgeInsets.only(top: 20),
                child: LineChart(LineChartData(
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: ListRevenue,
                        colors: [Colors.green],
                        isCurved: true,
                      ),
                      LineChartBarData(
                        spots: ListExpenditure,
                        colors: [Colors.red],
                        isCurved: true,
                      )
                    ])),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                width: 150,
                child: DataTable(columns: [
                  DataColumn(
                      label: Text('Month', style: addtextStyle.textstyle)),
                  DataColumn(
                      label: Text('Revenue', style: addtextStyle.textstyle)),
                  DataColumn(
                      label: Text('Expaditure', style: addtextStyle.textstyle)),
                  DataColumn(
                      label: Text('Risk', style: addtextStyle.textstyle)),
                ], rows: [
                  DataRow(cells: [
                    DataCell(Text('1')),
                    DataCell(Text('200')),
                    DataCell(Text('100')),
                    DataCell(Text('100')),
                  ])
                ]),
              ),
            ],
          ),
        ));
  }
}

final List<FlSpot> ListRevenue = [
  FlSpot(1, 4000000),
  FlSpot(2, 5000000),
  FlSpot(3, 2000000),
  FlSpot(4, 8000000),
  FlSpot(5, 9000000),
  FlSpot(6, 10000000),
  FlSpot(7, 1000000),
  FlSpot(8, 2500000),
  FlSpot(9, 5600000),
  FlSpot(10, 7000000),
  FlSpot(11, 3000000),
  FlSpot(12, 9000000),
];

final List<FlSpot> ListExpenditure = [
  FlSpot(1, 1000000),
  FlSpot(2, 5000000),
  FlSpot(3, 2000000),
  FlSpot(4, 3000000),
  FlSpot(5, 9000000),
  FlSpot(6, 1000000),
  FlSpot(7, 1000000),
  FlSpot(8, 2000000),
  FlSpot(9, 600000),
  FlSpot(10, 6000000),
  FlSpot(11, 000000),
  FlSpot(12, 10000000),
];

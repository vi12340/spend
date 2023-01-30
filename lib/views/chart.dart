import 'package:pie_chart/pie_chart.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/views/chartLine.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:animated_button_bar/animated_button_bar.dart';

class chart extends StatefulWidget {
  const chart({super.key});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  DbHelper? dbHelper;
  bool _opacity1 = true;
  bool _opacity2 = true;

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => chartLine()));
              },
              icon: Icon(MdiIcons.chartLine))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 180,
                child: AnimatedButtonBar(
                    radius: 25,
                    borderColor: Colors.white,
                    borderWidth: 2,
                    innerVerticalPadding: 15,
                    children: [
                      ButtonBarEntry(
                          child: Text('Thu nhập'),
                          onTap: () {
                            setState(() {
                              _opacity1 = true;
                              _opacity2 = false;
                            });
                          }),
                      ButtonBarEntry(
                          child: Text('Chi tiêu'),
                          onTap: () {
                            setState(() {
                              _opacity2 = true;
                              _opacity1 = false;
                            });
                          })
                    ]),
              ),
            ),
            Visibility(
                visible: _opacity1,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FutureBuilder(
                      future: dbHelper!.getSumInCome(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                         Map<String, double> dataMap ={};
                          for (int i = 0; i<= snapshot.data!.length; i++){
                            String name = snapshot.data![i].name;
                            double price = snapshot.data![i].price;
                            Map<String, double> data = {name:price};
                            dataMap.addAll(data);
                          }
                          return PieChart(dataMap: dataMap);
                        }
                        else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )),
            Visibility(
                visible: _opacity2,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FutureBuilder(
                    future: dbHelper!.getSumSpend(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

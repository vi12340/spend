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
  bool _opacity2 = false;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 180,
                  child:
                  AnimatedButtonBar(
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
                  child: inCome()),

              Visibility(
                  visible: _opacity2,
                  child: spend())
            ],
          ),
        ),
      ),
    );
  }
  Widget inCome(){
    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder(
          future: dbHelper!.getSumInCome(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, double> dataMap ={};
              List<Color> color = [];
              if(snapshot.data.length > 0){
                for (int i = 0; i< snapshot.data!.length; i++){
                  String name = snapshot.data![i]['name'];
                  double price = snapshot.data![i]['SUM(price)'].toDouble();

                  Map<String, double> data = {name:price};
                  dataMap.addAll(data);

                  List<Color> inColor = [Color(int.parse(snapshot.data[i]['color']))];
                  color.addAll(inColor);

                }
              }
              else{
                Map<String, double> data = {'Income':100};
                dataMap.addAll(data);

                List<Color> inColor = [Colors.green];
                color.addAll(inColor);
              }

              return Column(
                children: [
                  PieChart(
                    dataMap: dataMap,
                    colorList: color,
                    chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.only(top: 20),
                    child: FutureBuilder(
                      future: dbHelper!.getSumInCome(),
                      builder: (context, index){
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: ListTile(
                                  leading: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(snapshot.data[index]['color'])),
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                          width: 25,
                                          child: Image.asset(snapshot.data[index]['icon'], color: Colors.white)),
                                    ),
                                  ),
                                  title: Text(snapshot.data[index]['name']),
                                  trailing: Text(snapshot.data[index]['SUM(price)'].toString()),
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
  Widget spend(){
    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder(
          future: dbHelper!.getSumSpend(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, double> dataMap ={};
              List<Color> color = [];

              if(snapshot.data.length > 0){
                for (int i = 0; i< snapshot.data!.length; i++){
                  String name = snapshot.data![i]['name'];
                  double price = snapshot.data![i]['SUM(price)'].toDouble();

                  Map<String, double> data = {name:price};
                  dataMap.addAll(data);

                  List<Color> inColor = [Color(int.parse(snapshot.data[i]['color']))];
                  color.addAll(inColor);

                }
              }
              else{
                Map<String, double> data = {'Spend':1};
                dataMap.addAll(data);

                List<Color> inColor = [Colors.red];
                color.addAll(inColor);
              }

              return Column(
                children: [
                  PieChart(
                    dataMap: dataMap,
                    colorList: color,
                    chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true
                    ),
                  ),

                  Container(
                    height: 300,
                    padding: EdgeInsets.only(top: 20),
                    child: FutureBuilder(
                      future: dbHelper!.getSumSpend(),
                      builder: (context, index){
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: ListTile(
                                  leading: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(snapshot.data[index]['color'])),
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                          width: 25,
                                          child: Image.asset(snapshot.data[index]['icon'], color: Colors.white)),
                                    ),
                                  ),
                                  title: Text(snapshot.data[index]['name']),
                                  trailing: Text(snapshot.data[index]['SUM(price)'].toString()),
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

}

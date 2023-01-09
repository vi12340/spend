import 'package:flutter/material.dart';
import 'package:spend/main.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import '../models/category.dart';
import 'package:intl/intl.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  int? first, second;
  String result = '';
  String text = '0';
  String? opp;
  DbHelper? dbHelper;
  late Future<List<manageModel>> listManage;
  late Future<List<categoryModel>> listCategory;
  final controller = TextEditingController();
  DateTime date = DateTime.now();
  List<String> items = ['Thu', 'Chi'];
  String? select;
  String icon = 'lib/assets/icons/game.png';
  String colors = '0xff7EA2E9';
  late int idCategory;

  Future _date(context) async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    if (picker != null && picker != date) {
      setState(() {
        date = picker;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    listManage = dbHelper!.getManage();
    listCategory = dbHelper!.getCategory();
  }

  void btnButton(String btnText) {
    if (btnText == 'C') {
      first = 0;
      second = 0;
      result = '';
      text = '';
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'X' ||
        btnText == '/') {
      first = int.parse(text);
      result = '';
      opp = btnText;
    } else if (btnText == '=') {
      second = int.parse(text);
      if (opp == '+') {
        result = (first! + second!).toString();
      } else if (opp == '-') {
        result = (first! - second!).toString();
      } else if (opp == 'X') {
        result = (first! * second!).toString();
      } else {
        result = (first! / second!).toString();
      }
    } else {
      result = int.parse(text + btnText).toString();
    }

    setState(() {
      text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          color: Colors.blue,
          child: Row(
            children: [Expanded(child: leadingAdd()), actionAdd()],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: const [
                                Icon(Icons.menu_book_outlined),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Expanded(child: Text('Thể loại')),
                                ),
                              ],
                            ),
                          ),
                          DropdownButton(
                              value: select,
                              onChanged: (value) {
                                select = value;
                              },
                              items: items.map((select) {
                                return DropdownMenuItem(
                                    value: select, child: Text(select));
                              }).toList()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: const [
                              Icon(Icons.date_range_outlined),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Expanded(child: Text('Ngày Tháng')),
                              ),
                            ],
                          )),
                          GestureDetector(
                            onTap: (){
                              _date(context);
                            },
                              child: Text(DateFormat("dd-MM-yyyy").format(date))),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.note_outlined),
                          Container(
                            width: 240,
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintText: 'Ghi chú'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 120,
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    check(),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      customOutLineButton('7'),
                      customOutLineButton('8'),
                      customOutLineButton('9'),
                      customOutLineButton('+'),
                    ],
                  ),
                  Row(
                    children: [
                      customOutLineButton('4'),
                      customOutLineButton('5'),
                      customOutLineButton('6'),
                      customOutLineButton('-'),
                    ],
                  ),
                  Row(
                    children: [
                      customOutLineButton('1'),
                      customOutLineButton('2'),
                      customOutLineButton('3'),
                      customOutLineButton('X'),
                    ],
                  ),
                  Row(
                    children: [
                      customOutLineButton('C'),
                      customOutLineButton('0'),
                      customOutLineButton('='),
                      customOutLineButton('/'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget customOutLineButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: OutlinedButton(
            onPressed: () {
              btnButton(value);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xffF0F0F0))),
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            )),
      ),
    );
  }

  Widget leadingAdd() {
    return Container(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23))),
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        child: FutureBuilder(
                            future: listCategory,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (contex, index) {
                                      final item = snapshot.data![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 4),
                                        child: Container(
                                          height: 50,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                icon = item.icon;
                                                colors = item.color;
                                                idCategory = item.idCategory!;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Card(
                                              child: ListTile(
                                                title: Text(item.name),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      );
                    });
              },
              child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(int.parse(colors))),
                  child: Center(
                      child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset(icon, color: Colors.white),
                  ))),
            ),
          ],
        ));
  }

  Widget actionAdd() {
    return Center(
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 30),
                ),
              )),
        ],
      ),
    );
  }

  Widget check() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          dbHelper!.insertManage(manageModel(
              idCategory: idCategory,
              price: int.parse(text),
              type: select.toString(),
              dateTime: DateFormat("yyyy-MM-dd").format(date),
              comment: ''));
          listManage = dbHelper!.getManage();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });
      },
      child: Icon(Icons.check),
    );
  }
}

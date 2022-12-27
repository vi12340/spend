import 'package:flutter/material.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/models/manage.dart';
import 'package:intl/intl.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  int? first, second;
  String result = '';
  String text = '';
  String? opp;
  DbHelper? dbHelper;
  final controller = TextEditingController();
  String date =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

  List<String> items = ['Thu', 'Chi'];
  String? select;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
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
    return SingleChildScrollView(
      child: Column(
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
            child: Expanded(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Row(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Row(
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
                          Text(date),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range_outlined),
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: Row(
              children: [
                const Expanded(child: Text('')),
                check(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
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
          )
        ],
      ),
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
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.purple),
                child: const Icon(Icons.directions_bike_outlined)),
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
            onPressed: (){
              dbHelper!.insertManage(manageModel(idCategory: 1, price: int.parse(text), type: select.toString(), dateTime: date, comment: ''));
              Navigator.pop(context);
              },
            child: Icon(Icons.check),
    );
  }
}

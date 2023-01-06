import 'package:flutter/material.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/views/icons.dart';
import 'package:string_to_hex/string_to_hex.dart';


class categoryAdd extends StatefulWidget {
  const categoryAdd({Key? key}) : super(key: key);

  @override
  State<categoryAdd> createState() => _categoryAddState();
}

class _categoryAddState extends State<categoryAdd> {
  DbHelper? dbHelper;
  late Future<List<categoryModel>> listCategory;
  final controller = TextEditingController();
   String icon= 'lib/assets/icons/game.png';
   String colors = '0xff7EA2E9';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    listCategory = dbHelper!.getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mới'),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffD8D8D8),
        padding: EdgeInsets.all(25),
        child:
        SingleChildScrollView(
          child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(int.parse(colors)),
                              borderRadius: BorderRadius.circular(50)
                          ),

                            child: Center(
                              child: SizedBox(
                                width: 38,
                                child: Image.asset(icon, color: Colors.white),
                              ),
                            ),
                          ),

                        Container(
                          width: 240,
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              hintText: 'Nhập tên phân loại',
                            ),
                          ),
                        ),
                        Container(
                            child: TextButton(
                                onPressed: () {
                                  dbHelper!.insertCategory(categoryModel(
                                      name: controller.text,
                                      icon: icon,
                                      color: colors.toString()));
                                 controller.clear();
                                },
                                child: const Text('Save')
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              child: Icon(
                                  Icons.color_lens_outlined, color: Colors.black)),
                          Container(
                            width: 60,
                            height: 30,
                            color: Color(int.parse(colors)),
                            padding: EdgeInsets.only(left: 15),
                          )
                        ],
                      ),
                    ),

                    Container(
                      height: 415,
                      margin: EdgeInsets.only(top: 20),
                      child: GridView.builder(
                          itemCount: listIcon.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15

                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      icon = listIcon[index].icon;
                                      colors = listIcon[index].color;
                                    });
                                  },
                                  child: Center(
                                    child: SizedBox(
                                      width: 35,
                                      child: Image.asset(listIcon[index].icon, width: 30),
                                    ),
                                  )
                              ),
                            );

                          }
                      ),

                    ),
                  ],
                ),
        )

        ),


    );
  }
}

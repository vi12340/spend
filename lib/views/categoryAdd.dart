import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/db_helper.dart';
import 'package:spend/views/icons.dart';

class categoryAdd extends StatefulWidget {
  const categoryAdd({Key? key}) : super(key: key);

  @override
  State<categoryAdd> createState() => _categoryAddState();
}

class _categoryAddState extends State<categoryAdd> {
  DbHelper? dbHelper;
  late Future<List<categoryModel>> listCategory;
  final controller = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)
                    ),
                      child: Icon(Icons.directions_bike_outlined)),
                  Container(
                    width: 240,
                    padding: EdgeInsets.only(left:10),
                    child:  TextField(
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
                      onPressed: (){
                        dbHelper!.insertCategory(categoryModel(name: controller.text, icon: 'MdiIcons.gamepadVariantOutline', color: 'Colors.grey'));
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
                        child: Icon(Icons.color_lens_outlined, color: Colors.blue)),
                    Container(
                      width: 60,
                      height: 30,
                      color: Colors.blue,
                      padding: EdgeInsets.only(left: 15),
                    )
                    ],
                  ),
              ),

              Container(
                height: 415,
                margin: EdgeInsets.only(top: 20),
                child: GridView.builder(
                    itemCount:listIcon.length ,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 5,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15

                    ),
                    itemBuilder: (context, index){
                      return selcet(listIcon[index].icon);
                    }
                ),

                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget selcet(IconData icon){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50)
      ),
      child: IconButton(
          onPressed: () {
          },
          icon: Icon(icon)),
    );
  }

}

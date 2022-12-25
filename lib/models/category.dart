import 'package:flutter/cupertino.dart';

class categoryModel {
  int? idCategory;
  String name;
  String icon;
  String color;

  categoryModel({this.idCategory,required this.name, required this.icon, required this.color});

  Map<String, dynamic> toMap() {
    return {'idCategory': idCategory, 'name': name,'icon':icon,'color':color};
  }

  categoryModel.fromMap(Map<String, dynamic> res)
      : idCategory = res['idCategory'],
        name = res['name'],
        icon = res['icon'],
        color = res['color'];
}

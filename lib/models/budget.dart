import 'dart:ffi';

class budgetModel {
  int? id;
  int price;
  String dateTime;

  budgetModel({  this.id, required this.price, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {'id': id, 'price': price, 'dateTime': dateTime};
  }

  budgetModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        price = res['price'],
        dateTime = res['dateTime'];
}

class manageModel {
  int? id;
  int idCategory;
  int price;
  String type;
  String dateTime;
  String comment;

  manageModel({this.id,required this.idCategory,required this.price,required this.type,required this.dateTime,
    required this.comment});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCategory': idCategory,
      'price': price,
      'type': type,
      'dateTime': dateTime,
      'comment': comment
    };
  }

  factory manageModel.fromMap(Map<String, dynamic> res)
  {
    return manageModel(
        id : res['id'],
        idCategory : res['idCategory'],
        price : res['price'],
        type : res['type'],
        dateTime : res['dateTime'],
        comment : res['comment']
    );
  }
}

class manageCategory {
  int? id;
  int idCategory;
  int price;
  String type;
  String dateTime;
  String comment;
  String name;
  String icon;
  String color;

  manageCategory(
      {this.id,
      required this.idCategory,
      required this.type,
      required this.price,
      required this.dateTime,
      required this.comment,
      required this.name,
      required this.icon,
      required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCategory': idCategory,
      'price': price,
      'type': type,
      'dateTime': dateTime,
      'comment': comment,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory manageCategory.fromMap(Map<String, dynamic> res) {
    return manageCategory(
      id: res['id'],
      idCategory: res['idCategory'],
      price: res['price'],
      type: res['type'],
      dateTime: res['dateTime'],
      comment: res['comment'],
      name: res['name'],
      icon: res['icon'],
      color: res['color'],
    );
  }

}

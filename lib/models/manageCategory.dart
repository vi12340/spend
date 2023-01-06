class manageCategory{
  int id;
  int idCategory;
  int price;
  String type;
  String dateTime;
  String comment;
  String name;
  String icon;
  String color;
  manageCategory({required this.id,required this.idCategory,required this.type,required this.price,required this.dateTime,required this.comment, required this.name, required this.icon, required this.color});

  factory manageCategory.fromMap(Map<String, dynamic> res)
  {
    return manageCategory(
        id : res['id'],
        idCategory : res['idCategory'],
        price : res['price'],
        type : res['type'],
        dateTime : res['dateTime'],
        comment : res['comment'],
        name : res['name'],
        icon : res['icon'],
        color : res['color'],
    );
  }
}
class sumName{
  String name;
  double price;
  sumName({required this.name,required this.price});

  factory sumName.fromMap(Map<String, dynamic> res)
  {
    return sumName(
        name : res['name'],
        price : res['price']
    );
  }
}
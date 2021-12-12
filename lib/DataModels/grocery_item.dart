class GroceryItem{

  int? id;
  String? name, quantity, unit, category;
  bool? status;
  DateTime? time;

  GroceryItem({this.id, this.time, this.name, this.quantity, this.unit, this.category, this.status});

  int getStatus(){

    return status! ? 1 : 0;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toString(),
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'status': getStatus(),
    };
  }
}

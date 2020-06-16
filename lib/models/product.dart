import 'package:meta/meta.dart';

class SingleProduct{
  SingleProduct({@required this.imageUrl,@required this.id,@required this.name, @required this.price, @required this.description });
  final imageUrl;
  final id;
  final String name;
  final int price;
  final String description;

  factory SingleProduct.fromMap(Map<String, dynamic> data , String documentID) {
    if(data == null){
      return null;
    }
    final String name = data['name'];
    final int price = data['price'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    return SingleProduct(
      id: documentID,
      imageUrl: imageUrl,
      name: name,
      price: price,
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}


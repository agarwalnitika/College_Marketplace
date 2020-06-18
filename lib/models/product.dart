import 'package:meta/meta.dart';

class SingleProduct{
  SingleProduct({@required this.imageUrl,@required this.id,@required this.name, @required this.price, @required this.description, this.owner,this.contact });
  final imageUrl;
  final id;
  final String name;
  final int price;
  final String description;
  final String owner;
  final int contact;

  factory SingleProduct.fromMap(Map<String, dynamic> data , String documentID ) {
    if(data == null){
      return null;
    }
    final String name = data['name'];
    final int price = data['price'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    final String owner = data['owner'];
    final int contact = data['contact'];
    return SingleProduct(
      id: documentID,
      imageUrl: imageUrl,
      name: name,
      price: price,
      description: description,
      owner: owner,
      contact: contact,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'description': description,
      'owner': owner,
      'contact': contact,
    };
  }
}


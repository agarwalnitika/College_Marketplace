import 'package:meta/meta.dart';

class SingleProduct{
  SingleProduct({@required this.imageUrl1,  this.imageUrl2, this.imageUrl3,@required this.id,@required this.name, @required this.price, @required this.description, this.owner,this.contact });
  final imageUrl1;
  final imageUrl2;
  final imageUrl3;
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
    final String imageUrl1 = data['imageUrl1'];
    final String imageUrl2 = data['imageUrl2'] == null ? "" :data['imageUrl2'];
    final String imageUrl3 = data['imageUrl3'] == null ? "" :data['imageUrl3'];
    final String owner = data['owner'];
    final int contact = data['contact'];
    return SingleProduct(
      id: documentID,
      imageUrl1: imageUrl1,
      imageUrl2: imageUrl2,
      imageUrl3: imageUrl3,
      name: name,
      price: price,
      description: description,
      owner: owner,
      contact: contact,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl1': imageUrl1,
      'imageUrl2': imageUrl2,
      'imageUrl3': imageUrl3,
      'name': name,
      'price': price,
      'description': description,
      'owner': owner,
      'contact': contact,
    };
  }
}


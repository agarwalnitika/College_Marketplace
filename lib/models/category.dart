import 'package:meta/meta.dart';

class Category{
  Category({@required this.id,@required this.name });
  final id;
  final String name;


  factory Category.fromMap(Map<String, dynamic> data , String documentID) {
    if(data == null){
      return null;
    }
    final String name = data['name'];

    return Category(
      id: documentID,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    print('abc');
    return {
      'name': name,
    };
  }
}


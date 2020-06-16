import 'package:meta/meta.dart';

class User {
  User({
    this.photoUrl,
    @required this.name,
    @required this.uid,
    @required this.phone,
  });

  final String uid;
  final String name;
  final String photoUrl;
  final String phone;

  factory User.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String phone = data['phone'];
    final String id = data['id'];

    return User(
      uid: id,
      name: name,
      phone: phone,
    );
  }

  Map<String, dynamic> toMap() {
    print('abc');
    return {
      'name': name,
      'phone': phone,
    };
  }
}

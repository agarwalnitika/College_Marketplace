import 'package:meta/meta.dart';

class DonationEvent{
  DonationEvent({this.imageUrl,@required this.id,@required this.name, @required this.date, @required this.description,@required this.owner,@required this.contact });
  final imageUrl;
  final id;
  final String name;
  final String date;
  final String description;
  final String owner;
  final int contact;

  factory DonationEvent.fromMap(Map<String, dynamic> data , String documentID ) {
    if(data == null){
      return null;
    }
    final String name = data['name'];
    final String date = data['date'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    final String owner = data['owner'];
    final int contact = data['contact'];
    return DonationEvent(
      id: documentID,
      imageUrl: imageUrl,
      name: name,
      date: date,
      description: description,
      owner: owner,
      contact: contact,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'date': date,
      'description': description,
      'owner': owner,
      'contact': contact,
    };
  }
}


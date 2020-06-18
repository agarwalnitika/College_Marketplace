import 'package:marketplace/models/category.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/services/api_path.dart';
import 'package:marketplace/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Future<void> create_edit_Product(SingleProduct productDetails);
  Future<void> create_edit_Category(Category categoryName);
  Future<void> create_edit_Donation(DonationEvent donationDetails);
  Future<void> deleteProduct(SingleProduct productDetails);
  Future<void> deleteCategory(Category category);
  Future<void> deleteDonation(DonationEvent donationDetails);
  Stream<List<SingleProduct>> myProductsStream();
  Stream<List<SingleProduct>> allProductsStream();
  Stream<List<Category>> allCategoriesStream();
  Stream<List<DonationEvent>> allDonationsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;




  Future<void> create_edit_Product(SingleProduct productDetails) async {

    await _service.setData(
      path1: APIPath.product_add1(uid, productDetails.id),
      path2: APIPath.product_add2(productDetails.id),
      data: productDetails.toMap(),
    );
  }


  Future<void> create_edit_Donation(DonationEvent donationDetails) async {

    await _service.setData(
      path1: APIPath.donation_add(donationDetails.id),
      path2: APIPath.donation_add(donationDetails.id),
      data: donationDetails.toMap(),
    );
  }


  Future<void> create_edit_Category(Category categoryName) async {

    await _service.setData(
      path1: APIPath.category_add(categoryName.id),
      path2: APIPath.category_add(categoryName.id),
      data: categoryName.toMap(),
    );

  }

  Future<void> deleteProduct(SingleProduct productDetails) async =>
      await _service.deleteData(
        path1: APIPath.product_add1(uid, productDetails.id),
        path2: APIPath.product_add2(productDetails.id),
      );


  Future<void> deleteDonation(DonationEvent donationDetails) async =>
      await _service.deleteData(
        path1: APIPath.donation_add(donationDetails.id),
        path2: APIPath.donation_add(donationDetails.id),
      );

  Future<void> deleteCategory(Category category) async =>
      await _service.deleteData(
        path1: APIPath.category_add(category.id),
        path2: APIPath.category_add(category.id),
      );



  Stream<List<User>> myUserInfo() => _service.collectionStream(
    path: APIPath.myInfo(uid),
    builder: (data, documentID) => User.fromMap(data),
  );

  Stream<List<DonationEvent>> allDonationsStream() => _service.collectionStream(
    path: APIPath.allDonations(),
    builder: (data, documentID) => DonationEvent.fromMap(data, documentID),
  );


  Stream<List<Category>> allCategoriesStream() => _service.collectionStream(
        path: APIPath.allCategories(),
        builder: (data, documentID) => Category.fromMap(data, documentID),
      );

  Stream<List<SingleProduct>> myProductsStream() => _service.collectionStream(
        path: APIPath.myProducts(uid),
        builder: (data, documentID) => SingleProduct.fromMap(data, documentID),
      );

  Stream<List<SingleProduct>> allProductsStream() => _service.collectionStream(
        path: APIPath.allProducts(),
        builder: (data, documentID) => SingleProduct.fromMap(data, documentID),
      );
}

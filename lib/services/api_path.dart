class APIPath {
  static String product_add1(String uid, String productId) => 'users/$uid/products/$productId';
  static String product_add2(String productId) => 'products/$productId';
  static String donation_add (String donationId)=> 'donations/$donationId';
  static String category_add(String categoryId) => 'categories/$categoryId';
  static String myProducts(String uid) => 'users/$uid/products';
  static String myInfo(String uid)=> 'users/$uid';
  static String allProducts() => 'products';
  static String allCategories()=> 'categories';
  static String allDonations() => 'donations';
}




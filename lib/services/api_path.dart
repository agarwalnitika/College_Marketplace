class APIPath {
  static String product_add1(String uid, String productId) => 'users/$uid/products/$productId';
  static String product_add2(String productId) => 'products/$productId';
  static String category_add(String categoryId) => 'categories/$categoryId';
  static String myProducts(String uid) => 'users/$uid/products';
  static String allProducts() => 'products';
  static String allCategories()=> 'categories';
}




class ApiUrls {
  ApiUrls._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String products = '/products';

   static String productDetails(int id) => '/products/$id';
}

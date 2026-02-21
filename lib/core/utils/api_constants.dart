class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://gallery.prod2.webant.ru';
  static const String mediaUrl = '$baseUrl/uploads/';

  static const String tokenEndpoint = '/token';
  static const String usersEndpoint = '/users';
  static const String photosEndpoint = '/photos';

  static const String clientId = '123';
  static const String clientSecret = '123';
  static const String grantTypePassword = 'password';
  static const String grantTypeRefresh = 'refresh_token';

  static const int itemsPerPage = 10;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

import 'package:dio/dio.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/features/auth/infrastructure/models/token_model.dart';
import 'package:webant_gallery/features/auth/infrastructure/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> authenticate(String email, String password);
  Future<TokenModel> refreshToken(String refreshToken);
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
    required String birthday,
    String? phone,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<TokenModel> authenticate(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.tokenEndpoint,
        data: {
          'client_id': ApiConstants.clientId,
          'client_secret': ApiConstants.clientSecret,
          'grant_type': ApiConstants.grantTypePassword,
          'username': email,
          'password': password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return TokenModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Ошибка авторизации',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.tokenEndpoint,
        data: {
          'client_id': ApiConstants.clientId,
          'client_secret': ApiConstants.clientSecret,
          'grant_type': ApiConstants.grantTypeRefresh,
          'refresh_token': refreshToken,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return TokenModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthException(
        e.response?.statusMessage ?? 'Ошибка обновления токена',
      );
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
    required String birthday,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.usersEndpoint,
        data: {
          'email': email,
          'plainPassword': password,
          'displayName': displayName,
          'birthday': birthday,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Ошибка регистрации';
      if (data is Map<String, dynamic>) {
        message = (data['detail'] as String?) ??
            (data['hydra:description'] as String?) ??
            message;
      }
      throw ServerException(message, statusCode: e.response?.statusCode);
    }
  }
}

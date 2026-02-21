import 'package:dio/dio.dart';
import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicEndpoint(options)) {
      return handler.next(options);
    }

    try {
      final token = await _tokenManager.getValidAccessToken();
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['Accept'] = 'application/ld+json';
      handler.next(options);
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isPublicEndpoint(err.requestOptions)) {
      try {
        final token = await _tokenManager.forceRefresh();
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';

        final response = await Dio().fetch(opts);
        return handler.resolve(response);
      } catch (_) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  bool _isPublicEndpoint(RequestOptions options) {
    return options.path == ApiConstants.tokenEndpoint ||
        (options.path == ApiConstants.usersEndpoint &&
            options.method == 'POST');
  }
}

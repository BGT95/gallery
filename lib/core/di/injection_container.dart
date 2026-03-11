import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webant_gallery/core/infrastructure/network/auth_interceptor.dart';
import 'package:webant_gallery/core/infrastructure/network/network_info.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/core/utils/api_constants.dart';
import 'package:webant_gallery/core/utils/logger.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/infrastructure/data_sources/auth_remote_data_source.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/auth_repository_impl.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/token_manager.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/infrastructure/data_sources/gallery_local_data_source.dart';
import 'package:webant_gallery/features/gallery/infrastructure/data_sources/gallery_remote_data_source.dart';
import 'package:webant_gallery/features/gallery/infrastructure/repos/gallery_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final authDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authDio),
  );
  sl.registerLazySingleton(
    () => TokenManager(sl<AuthRemoteDataSource>(), sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      tokenManager: sl<TokenManager>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  final apiDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );
  apiDio.interceptors.add(AuthInterceptor(sl<TokenManager>(), apiDio));
  if (kDebugMode) {
    apiDio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: false),
    );
  }
  sl.registerLazySingleton<Dio>(() => apiDio);

  AppLogger.info('DI initialized');

  sl.registerLazySingleton<GalleryRemoteDataSource>(
    () => GalleryRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<GalleryLocalDataSource>(
    () => GalleryLocalDataSourceImpl.create(),
  );

  sl.registerLazySingleton<GalleryRepository>(
    () => GalleryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GoRouter>(() => createRouter());
}

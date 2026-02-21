import 'package:dartz/dartz.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/core/infrastructure/network/network_info.dart';
import 'package:webant_gallery/core/utils/logger.dart';
import 'package:webant_gallery/features/auth/domain/entities/user.dart';
import 'package:webant_gallery/features/auth/domain/repos/auth_repository.dart';
import 'package:webant_gallery/features/auth/infrastructure/data_sources/auth_remote_data_source.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/token_manager.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenManager tokenManager,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _tokenManager = tokenManager,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _tokenManager.signIn(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Sign in failed: ${e.message}', error: e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Sign in unexpected error', error: e);
      return const Left(AuthFailure('Неверный email или пароль'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String displayName,
    required DateTime birthday,
    String? phone,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      AppLogger.auth('Registering: $email');
      final user = await _remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
        birthday: birthday.toIso8601String(),
        phone: phone,
      );
      await _tokenManager.signIn(email, password);
      AppLogger.auth('Registration successful: ${user.id}');
      return Right(user);
    } on ServerException catch (e) {
      AppLogger.error('Registration failed: ${e.message}', error: e);
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      AppLogger.error('Registration unexpected error', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  bool get isAuthenticated => _tokenManager.isAuthenticated;

  @override
  Future<void> signOut() => _tokenManager.signOut();
}

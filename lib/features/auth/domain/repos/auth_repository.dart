import 'package:dartz/dartz.dart';
import 'package:webant_gallery/core/domain/failures.dart';
import 'package:webant_gallery/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String displayName,
    required DateTime birthday,
    String? phone,
  });

  bool get isAuthenticated;

  Future<void> signOut();
}

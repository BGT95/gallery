import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webant_gallery/core/domain/exceptions.dart';
import 'package:webant_gallery/core/utils/logger.dart';
import 'package:webant_gallery/features/auth/infrastructure/data_sources/auth_remote_data_source.dart';
import 'package:webant_gallery/features/auth/infrastructure/models/token_model.dart';

class TokenManager {
  final AuthRemoteDataSource _authDataSource;
  final SharedPreferences _prefs;

  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';

  TokenModel? _currentToken;
  String? _email;
  Completer<TokenModel>? _refreshCompleter;

  TokenManager(this._authDataSource, this._prefs) {
    _loadFromStorage();
  }

  bool get isAuthenticated =>
      _currentToken != null && !_currentToken!.isExpired;

  String? get currentEmail => _email;

  void _loadFromStorage() {
    final json = _prefs.getString(_tokenKey);
    if (json != null) {
      try {
        _currentToken = TokenModel.fromStorageJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
        _email = _prefs.getString(_emailKey);
        AppLogger.auth('Token loaded from storage (expired: ${_currentToken!.isExpired})');
      } catch (e) {
        AppLogger.error('Failed to load token from storage', error: e);
        _prefs.remove(_tokenKey);
      }
    }
  }

  Future<void> _saveToStorage(TokenModel token) async {
    await _prefs.setString(_tokenKey, jsonEncode(token.toStorageJson()));
    if (_email != null) {
      await _prefs.setString(_emailKey, _email!);
    }
  }

  Future<String> signIn(String email, String password) async {
    AppLogger.auth('Signing in: $email');
    final token = await _authDataSource.authenticate(email, password);
    _currentToken = token;
    _email = email;
    await _saveToStorage(token);
    AppLogger.auth('Sign in successful');
    return token.accessToken;
  }

  Future<String> getValidAccessToken() async {
    if (_currentToken != null && !_currentToken!.isExpired) {
      return _currentToken!.accessToken;
    }
    if (_currentToken != null) {
      return (await _ensureToken()).accessToken;
    }
    throw const AuthException('Не авторизован');
  }

  Future<TokenModel> _ensureToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<TokenModel>();

    try {
      AppLogger.auth('Refreshing token...');
      final token = await _authDataSource.refreshToken(
        _currentToken!.refreshToken,
      );
      _currentToken = token;
      await _saveToStorage(token);
      _refreshCompleter!.complete(token);
      AppLogger.auth('Token refreshed');
      return token;
    } catch (e) {
      AppLogger.error('Token refresh failed', error: e);
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<String> forceRefresh() async {
    if (_currentToken == null) {
      throw const AuthException('Не авторизован');
    }
    _refreshCompleter = null;
    return (await _ensureToken()).accessToken;
  }

  Future<void> signOut() async {
    AppLogger.auth('Signing out');
    _currentToken = null;
    _email = null;
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_emailKey);
  }
}

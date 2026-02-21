class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime obtainedAt;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    DateTime? obtainedAt,
  }) : obtainedAt = obtainedAt ?? DateTime.now();

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }

  Map<String, dynamic> toStorageJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'obtained_at': obtainedAt.toIso8601String(),
  };

  factory TokenModel.fromStorageJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      obtainedAt: DateTime.parse(json['obtained_at'] as String),
    );
  }

  bool get isExpired =>
      DateTime.now().isAfter(obtainedAt.add(Duration(seconds: expiresIn - 60)));
}

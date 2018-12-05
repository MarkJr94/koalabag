class Auth {
  final String accessToken;
  final DateTime expiresAt;
  final String scope;
  final String tokenType;
  final String refreshToken;
  final String clientId;
  final String clientSecret;
  final String origin;

  Auth(
      {this.accessToken,
        this.expiresAt,
        this.scope,
        this.tokenType,
        this.refreshToken,
        this.clientId,
        this.clientSecret,
        this.origin});

  factory Auth.fromNet(Map<String, dynamic> json,
                       {String clientId, String clientSecret, String origin}) {
    final expSpan = Duration(seconds: json["expires_in"]);

    return Auth(
        accessToken: json['access_token'],
        expiresAt: DateTime.now().add(expSpan),
        scope: null,
        tokenType: json['token_type'],
        refreshToken: json['refresh_token'],
        clientId: clientId,
        clientSecret: clientSecret,
        origin: origin);
  }

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        accessToken: json['accessToken'],
        expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expiresAt']),
        scope: null,
        tokenType: json['tokenType'],
        refreshToken: json['refreshToken'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        origin: json['origin']);
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'scope': scope,
      'tokenType': tokenType,
      'refreshToken': refreshToken,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'origin': origin
    };
  }

  bool isExpired() {
    final now = DateTime.now();

    return (expiresAt.compareTo(now) <= 0);
  }
}
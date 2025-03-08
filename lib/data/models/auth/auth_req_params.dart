class AuthReqParams {
  String? sessionId;
  String? name;
  String? email;
  String? password;

  AuthReqParams({
    this.sessionId,
    this.name,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sessionId':sessionId,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

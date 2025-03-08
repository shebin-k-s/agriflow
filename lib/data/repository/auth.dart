import 'package:dartz/dartz.dart';

import '../../domain/repository/auth/auth.dart';
import '../../service_locator.dart';
import '../models/auth/auth_req_params.dart';
import '../source/auth/auth_api_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(AuthReqParams signupReq) {
    return sl<AuthApiService>().signup(signupReq);
  }

  @override
  Future<Either> signin(AuthReqParams signinReq) {
    return sl<AuthApiService>().signin(signinReq);
  }

  @override
  Future<Either> forgotPassword(emailData) {
    return sl<AuthApiService>().forgotPassword(emailData);
  }

  @override
  Future<Either> resetPassword(resetData) {
    return sl<AuthApiService>().resetPassword(resetData);
  }

  @override
  Future<Either> sendOTP(emailData) {
    return sl<AuthApiService>().sendOTP(emailData);
  }

  @override
  Future<Either> verifyOTP(otpData) {
    return sl<AuthApiService>().verifyOTP(otpData);
  }
}

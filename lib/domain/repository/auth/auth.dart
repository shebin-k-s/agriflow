import 'package:dartz/dartz.dart';

import '../../../data/models/auth/auth_req_params.dart';

abstract class AuthRepository {

  Future<Either> signup(AuthReqParams signupReq);
  Future<Either> signin(AuthReqParams signinReq);

  Future<Either> forgotPassword(dynamic emailData);
  Future<Either> resetPassword(dynamic resetData);

  Future<Either> sendOTP(dynamic emailData);
  Future<Either> verifyOTP(dynamic otpData);



}
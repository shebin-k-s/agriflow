import 'dart:developer';
import 'package:agriflow/core/network/dio_client.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_urls.dart';
import '../../models/auth/auth_req_params.dart';

abstract class AuthApiService {
  Future<Either> signup(AuthReqParams signupReq);
  Future<Either> signin(AuthReqParams signinReq);

  Future<Either> forgotPassword(dynamic emailData);
  Future<Either> resetPassword(dynamic resetData);

  Future<Either> sendOTP(dynamic emailData);
  Future<Either> verifyOTP(dynamic otpData);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> signup(AuthReqParams signupReq) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.signup,
        data: signupReq.toMap(),
      );
      return Right(response.data['message']);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> signin(AuthReqParams signinReq) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.signin,
        data: signinReq.toMap(),
      );

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.clear();

      if (response.data['token'] != null) {
        final sharedPref = await SharedPreferences.getInstance();

        sharedPref.setString("TOKEN", response.data['token']);
        sharedPref.setString("NAME", response.data['name']);
        sharedPref.setString("EMAIL", response.data['email']);

        return Right(response.data['message']);
      }
      return Left(response.data['message']);
    } on DioException catch (e) {
      log(e.toString());
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> forgotPassword(emailData) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.forgotPassword,
        data: emailData,
      );
      if (response.data['sessionId'] != null) {
        final sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("SESSIONID", response.data['sessionId']);
      } else {
        return const Left("Failed to send otp");
      }
      return Right(response.data['message']);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> resetPassword(resetData) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.resetPassword,
        data: resetData,
      );
      return Right(response.data['message']);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> sendOTP(emailData) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.sendOTP,
        data: emailData,
      );
      if (response.data['sessionId'] != null) {
        final sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("SESSIONID", response.data['sessionId']);
      } else {
        return const Left("Failed to send otp");
      }
      return Right(response.data['message']);
    } on DioException catch (e) {
      print(e);
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> verifyOTP(otpData) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.verifyOTP,
        data: otpData,
      );
      return Right(response.data['message']);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }
}

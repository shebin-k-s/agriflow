import 'package:agriflow/core/network/dio_client.dart';
import 'package:agriflow/data/repository/field.dart';
import 'package:agriflow/data/source/field/field_api_service.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/domain/usecases/field/add_field.dart';
import 'package:agriflow/domain/usecases/field/fetch_field.dart';
import 'package:get_it/get_it.dart';

import 'data/repository/auth.dart';
import 'data/source/auth/auth_api_service.dart';
import 'domain/repository/auth/auth.dart';
import 'domain/usecases/auth/forgot_password.dart';
import 'domain/usecases/auth/reset_password.dart';
import 'domain/usecases/auth/send_otp.dart';
import 'domain/usecases/auth/signin.dart';
import 'domain/usecases/auth/signup.dart';
import 'domain/usecases/auth/verify_otp.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  //services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<FieldApiService>(FieldApiServiceImpl());

  //repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<FieldRepository>(FieldRepositoryImpl());

  //auth usecase
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<ForgotPasswordUseCase>(ForgotPasswordUseCase());
  sl.registerSingleton<ResetPasswordUsecase>(ResetPasswordUsecase());

  sl.registerSingleton<SendOtpUseCase>(SendOtpUseCase());
  sl.registerSingleton<VerifyOtpUsecase>(VerifyOtpUsecase());

  //device usecase
  sl.registerSingleton<AddFieldUsecase>(AddFieldUsecase());
  sl.registerSingleton<FetchFieldUsecase>(FetchFieldUsecase());
}

import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/auth/auth_req_params.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class SignupUseCase implements UseCase<Either, AuthReqParams> {
  @override
  Future<Either> call({AuthReqParams? param}) {
    return sl<AuthRepository>().signup(param!);
  }
}

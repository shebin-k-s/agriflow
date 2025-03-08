import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class ResetPasswordUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({param}) {
    return sl<AuthRepository>().resetPassword(param);
  }
}

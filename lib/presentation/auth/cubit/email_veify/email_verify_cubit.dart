import 'package:bloc/bloc.dart';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../domain/usecases/auth/send_otp.dart';
import '../../../../service_locator.dart';

part 'email_verify_state.dart';

class EmailVerifyCubit extends Cubit<EmailVerifyState> {
  EmailVerifyCubit() : super(EmailVerifyInitial());

  void verifyEmail(String email) async {
    emit(VerifyLoading());
    Either result = await sl<SendOtpUseCase>().call(
      param: {"email": email},
    );
    result.fold(
      (error) {
        emit(EmailNotVerified(message: error));
      },
      (data) {
        emit(OtpSend(message: data));
      },
    );
  }

  void onVerified() {
    emit(EmailVerified());
  }
}

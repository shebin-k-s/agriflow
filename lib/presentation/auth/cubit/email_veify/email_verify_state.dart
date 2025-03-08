part of 'email_verify_cubit.dart';

@immutable
sealed class EmailVerifyState {}

class EmailVerifyInitial extends EmailVerifyState {}

class EmailNotVerified extends EmailVerifyState {
  final String message;

  EmailNotVerified({required this.message});
}

class OtpSend extends EmailVerifyState {
  final String message;

  OtpSend({required this.message});
}

class EmailVerified extends EmailVerifyState {}

class VerifyLoading extends EmailVerifyState {}

part of 'user_details_cubit.dart';

@immutable
sealed class UserDetailsState {}

final class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final String fullName;
  final String email;

  UserDetailsLoaded({
    required this.fullName,
    required this.email,
  });
}

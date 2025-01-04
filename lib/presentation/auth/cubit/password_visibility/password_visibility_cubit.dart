import 'package:bloc/bloc.dart';

part 'password_visibility_state.dart';

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit()
      : super(PasswordVisibilityState(showPassword: false));

  void toggleVisibility() {
    emit(
      PasswordVisibilityState(showPassword: !state.showPassword),
    );
  }
}

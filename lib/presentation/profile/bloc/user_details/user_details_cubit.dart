import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsLoading());

  void loadUserDetails() async {
    final sharedPref = await SharedPreferences.getInstance();
    final fullName = sharedPref.getString("NAME") ?? "";
    final email = sharedPref.getString("EMAIL") ?? "";

    emit(
      UserDetailsLoaded(fullName: fullName, email: email),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonInitial());

  void execute() async {
    try {
      emit(ButtonLoadingState());
      await Future.delayed(const Duration(seconds: 3));
      emit(ButtonSuccessState(message: "ssuccess"));
      // Either result = await usecase.call(param: params);

      // result.fold(
      //   (error) {
      //     emit(
      //       ButtonFailureState(message: error),
      //     );
      //   },
      //   (data) {
      //     emit(ButtonSuccessState(message: data));
      //   },
      // );
    } catch (e) {
      emit(
        ButtonFailureState(message: e.toString()),
      );
    }
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecase/usecase.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonInitial());
  void execute({dynamic params, required UseCase usecase}) async {
    try {
      emit(ButtonLoadingState());
      Either result = await usecase.call(param: params);
      result.fold(
        (error) {
          emit(
            ButtonFailureState(message: error),
          );
        },
        (data) {
          emit(ButtonSuccessState(message: data));
        },
      );
    } catch (e) {
      emit(
        ButtonFailureState(message: e.toString()),
      );
    }
  }
}

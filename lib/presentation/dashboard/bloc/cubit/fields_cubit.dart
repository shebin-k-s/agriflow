import 'dart:developer';

import 'package:agriflow/domain/entities/field/field.dart';
import 'package:agriflow/domain/usecases/field/fetch_field.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../service_locator.dart';

part 'fields_state.dart';

class FieldsCubit extends Cubit<FieldsState> {
  FieldsCubit() : super(FieldsLoading());

  void loadFields() async {
    Either result = await sl<FetchFieldUsecase>().call();

    return result.fold(
      (error) async {
        log(error.toString());

        await Future.delayed(
          const Duration(seconds: 5),
        );
        loadFields();
      },
      (fields) {
        log(fields.toString());
        emit(
          FieldsLoaded(fields: fields),
        );
      },
    );
  }

  void reset() {
    FieldsLoading();
  }
}

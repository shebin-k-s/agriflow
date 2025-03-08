import 'package:agriflow/core/usecase/usecase.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';

class FetchFieldUsecase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({param}) {
    return sl<FieldRepository>().fetchField();
  }
}

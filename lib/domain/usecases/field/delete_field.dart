import 'package:agriflow/core/usecase/usecase.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeleteFieldUsecase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? param}) {
    return sl<FieldRepository>().deleteField(param!);
  }
}

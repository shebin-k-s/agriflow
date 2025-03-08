import 'package:agriflow/core/usecase/usecase.dart';
import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';

class AddFieldUsecase implements UseCase<Either,FieldReqParams> {
  @override
  Future<Either> call({FieldReqParams? param}) {
   return sl<FieldRepository>().addField(param!);
  }
}
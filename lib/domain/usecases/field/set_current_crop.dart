import 'package:agriflow/core/usecase/usecase.dart';
import 'package:agriflow/data/models/currentCrop/current_crop_req_params.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';

class SetCurrentCropUsecase implements UseCase<Either,CurrentCropReqParams> {
  @override
  Future<Either> call({CurrentCropReqParams? param}) {
   return sl<FieldRepository>().setCurrentCrop(param!);
  }
}
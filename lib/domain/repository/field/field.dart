import 'package:agriflow/data/models/currentCrop/current_crop_req_params.dart';
import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:dartz/dartz.dart';

abstract class FieldRepository {
  Future<Either> addField(FieldReqParams device);
  Future<Either> fetchField();
  Future<Either> deleteField(String fieldId);
  Future<Either> predictCrop(String fieldId);
  Future<Either> setCurrentCrop(CurrentCropReqParams crop);
}

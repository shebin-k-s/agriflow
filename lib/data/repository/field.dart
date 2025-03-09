import 'package:agriflow/data/models/currentCrop/current_crop_req_params.dart';
import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/data/source/field/field_api_service.dart';
import 'package:agriflow/domain/repository/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';

class FieldRepositoryImpl extends FieldRepository {
  @override
  Future<Either> addField(FieldReqParams device) {
    return sl<FieldApiService>().addField(device);
  }

  @override
  Future<Either> fetchField() {
    return sl<FieldApiService>().fetchField();
  }

  @override
  Future<Either> deleteField(String fieldId) {
    return sl<FieldApiService>().deleteField(fieldId);
  }

  @override
  Future<Either> predictCrop(String fieldId) {
    return sl<FieldApiService>().predictCrops(fieldId);
  }
  
  @override
  Future<Either> setCurrentCrop(CurrentCropReqParams crop) {
      return sl<FieldApiService>().setCurrentCrops(crop);

  }
}

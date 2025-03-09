import 'dart:developer';

import 'package:agriflow/core/constants/api_urls.dart';
import 'package:agriflow/core/network/dio_client.dart';
import 'package:agriflow/data/models/currentCrop/current_crop_req_params.dart';
import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/domain/entities/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class FieldApiService {
  Future<Either> addField(FieldReqParams field);
  Future<Either> fetchField();
  Future<Either> deleteField(String fieldId);
  Future<Either> predictCrops(String fieldId);
  Future<Either> setCurrentCrops(CurrentCropReqParams crop);
}

class FieldApiServiceImpl extends FieldApiService {
  @override
  Future<Either> addField(FieldReqParams field) async {
    try {
      log(field.toString());
      var response = await sl<DioClient>().post(
        ApiUrls.addField,
        data: field.toMap(),
      );

      return Right(response.data['message']);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> fetchField() async {
    try {
      log("fetching");
      var response = await sl<DioClient>().get(
        ApiUrls.fetchFields,
      );

      if (response.data['fields'] != null) {
        List<dynamic> fieldsData = response.data["fields"];
        print(fieldsData);
        List<FieldData> fields = fieldsData
            .map(
              (field) => FieldData.fromJson(field),
            )
            .toList();

        return Right(fields);
      }

      return const Left("Error");
    } on DioException catch (e) {
      log(e.toString());
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> deleteField(String fieldId) async {
    try {
      log("Deleting field with ID: $fieldId");

      var response = await sl<DioClient>().delete(
        "${ApiUrls.deleteField}$fieldId",
      );

      return Right(response['message']);
    } on DioException catch (e) {
      log("Delete Error: ${e.toString()}");
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }

  @override
  Future<Either> predictCrops(String fieldId) async {
    try {
      log("Fetching crop recommendation for field: $fieldId");

      var response = await sl<DioClient>().get(
        "${ApiUrls.predictCropRecommendation}$fieldId",
      );
      if (response.statusCode == 200) {
        return Right(response.data['fieldId'] ?? fieldId);
      } else {
        return Left(
            response.data['fieldId'] ?? fieldId);
      }
    } on DioException catch (e) {
      log("Crop recommendation fetch error: ${e.toString()}");
      return Left(e.response?.data['fieldId'] ?? fieldId);
    }
  }

  @override
  Future<Either> setCurrentCrops(CurrentCropReqParams crop) async {
    try {
      print(crop);
      var response = await sl<DioClient>()
          .post(ApiUrls.setCurrentCrop, data: crop.toMap());
      print(response);
      return const Right("success");
    } on DioException catch (e) {
      log("Delete Error: ${e.toString()}");
      return Left(e.response?.data['message'] ?? "Network error");
    }
  }
}

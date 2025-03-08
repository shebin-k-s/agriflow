import 'dart:developer';

import 'package:agriflow/core/constants/api_urls.dart';
import 'package:agriflow/core/network/dio_client.dart';
import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/domain/entities/field/field.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class FieldApiService {
  Future<Either> addField(FieldReqParams field);
  Future<Either> fetchField();
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
}

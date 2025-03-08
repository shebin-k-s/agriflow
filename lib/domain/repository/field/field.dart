import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:dartz/dartz.dart';

abstract class FieldRepository {
  Future<Either> addField(FieldReqParams device);
  Future<Either> fetchField();
}

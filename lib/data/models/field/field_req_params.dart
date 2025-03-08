
class FieldReqParams {
  String? fieldName;
  String? deviceId;
  String? serialNumber;

  FieldReqParams({
    this.fieldName,
    this.deviceId,
    this.serialNumber,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fieldName': fieldName,
      'deviceId': deviceId,
      'serialNumber': serialNumber,
    };
  }
}
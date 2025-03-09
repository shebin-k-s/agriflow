
class FieldReqParams {
  String? fieldName;
  String? deviceId;
  String? serialNumber;
  String? address;
  double? latitude;
  double? longitude;

  FieldReqParams({
    this.fieldName,
    this.deviceId,
    this.serialNumber,
    this.address,
    this.latitude,
    this.longitude
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fieldName': fieldName,
      'deviceId': deviceId,
      'serialNumber': serialNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
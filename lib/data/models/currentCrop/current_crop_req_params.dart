class CurrentCropReqParams {
  String? fieldId;
  String? currentCrop;
 

  CurrentCropReqParams({
    this.fieldId,
    this.currentCrop,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fieldId': fieldId,
      'currentCrop': currentCrop
    };
  }
}
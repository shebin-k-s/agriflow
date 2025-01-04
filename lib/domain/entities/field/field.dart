class FieldEntity {
  final String name;
  final String currentCrop;
  final double moisture;
  final double temperature;
  final double pH;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final String deviceId;

  FieldEntity({
    required this.name,
    required this.currentCrop,
    required this.moisture,
    required this.temperature,
    required this.pH,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.deviceId,
  });
}

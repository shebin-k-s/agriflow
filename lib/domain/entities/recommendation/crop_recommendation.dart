class CropRecommendationEntity {
  final String fieldName;
  final List<Crops> crops;

  CropRecommendationEntity({
    required this.fieldName,
    required this.crops,
  });
}

class Crops {
  final String cropName;
  final int percentage;
  final String description;

  Crops({
    required this.cropName,
    required this.percentage,
    required this.description,
  });
}

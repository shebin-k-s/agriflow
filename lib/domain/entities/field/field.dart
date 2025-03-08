import 'dart:convert';

class FieldData {
  final String id;
  final String fieldName;
  final String deviceId;
  final String serialNumber;
  final String address;
  final String currentCrop;
  final Location location;
  final SensorReadings sensorReadings;
  final NutrientsNeeded nutrientsNeeded;
  final double annualRainfall;
  final double annualTemperature;
  final List<CropRecommendation> cropRecommendations;
  final DateTime createdAt;

  FieldData({
    required this.id,
    required this.fieldName,
    required this.deviceId,
    required this.serialNumber,
    required this.address,
    required this.currentCrop,
    required this.location,
    required this.sensorReadings,
    required this.nutrientsNeeded,
    required this.annualRainfall,
    required this.annualTemperature,
    required this.cropRecommendations,
    required this.createdAt,
  });

  factory FieldData.fromJson(Map<String, dynamic> json) {
    return FieldData(
      id: json['_id'] ?? '',
      fieldName: json['fieldName'] ?? '',
      deviceId: json['deviceId'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      address: json['address'] ?? '',
      currentCrop: json['currentCrop'] ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : Location(type: "Point", coordinates: []),
      sensorReadings: json['sensorReadings'] != null
          ? SensorReadings.fromJson(json['sensorReadings'])
          : SensorReadings(moisture: 0, temperature: 0, pH: 0, nitrogen: 0, phosphorus: 0, potassium: 0),
      nutrientsNeeded: json['nutrientsNeeded'] != null
          ? NutrientsNeeded.fromJson(json['nutrientsNeeded'])
          : NutrientsNeeded(nitrogen: 0, phosphorus: 0, potassium: 0),
      annualRainfall: (json['annualRainfall'] ?? 0).toDouble(),
      annualTemperature: (json['annualTemperature'] ?? 0).toDouble(),
      cropRecommendations: (json['cropRecommendations'] as List?)
              ?.map((item) => CropRecommendation.fromJson(item))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fieldName': fieldName,
      'deviceId': deviceId,
      'serialNumber': serialNumber,
      'address': address,
      'currentCrop': currentCrop,
      'location': location.toJson(),
      'sensorReadings': sensorReadings.toJson(),
      'nutrientsNeeded': nutrientsNeeded.toJson(),
      'annualRainfall': annualRainfall,
      'annualTemperature': annualTemperature,
      'cropRecommendations': cropRecommendations.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location(type: "Point", coordinates: []);
    }
    return Location(
      type: json['type'] ?? "Point",
      coordinates: (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class SensorReadings {
  final double moisture;
  final double temperature;
  final double pH;
  final double nitrogen;
  final double phosphorus;
  final double potassium;

  SensorReadings({
    required this.moisture,
    required this.temperature,
    required this.pH,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });

  factory SensorReadings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SensorReadings(moisture: 0, temperature: 0, pH: 0, nitrogen: 0, phosphorus: 0, potassium: 0);
    }
    return SensorReadings(
      moisture: (json['moisture'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      pH: (json['pH'] ?? 0).toDouble(),
      nitrogen: (json['nitrogen'] ?? 0).toDouble(),
      phosphorus: (json['phosphorus'] ?? 0).toDouble(),
      potassium: (json['potassium'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moisture': moisture,
      'temperature': temperature,
      'pH': pH,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
    };
  }
}

class NutrientsNeeded {
  final double nitrogen;
  final double phosphorus;
  final double potassium;

  NutrientsNeeded({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });

  factory NutrientsNeeded.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return NutrientsNeeded(nitrogen: 0, phosphorus: 0, potassium: 0);
    }
    return NutrientsNeeded(
      nitrogen: (json['nitrogen'] ?? 0).toDouble(),
      phosphorus: (json['phosphorus'] ?? 0).toDouble(),
      potassium: (json['potassium'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
    };
  }
}

class CropRecommendation {
  final String crop;
  final double compositeScore;
  final double conditionMatch;
  final double yieldScore;
  final String id;

  CropRecommendation({
    required this.crop,
    required this.compositeScore,
    required this.conditionMatch,
    required this.yieldScore,
    required this.id,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CropRecommendation(crop: '', compositeScore: 0, conditionMatch: 0, yieldScore: 0, id: '');
    }
    return CropRecommendation(
      crop: json['crop'] ?? '',
      compositeScore: (json['composite_score'] ?? 0).toDouble(),
      conditionMatch: (json['condition_match'] ?? 0).toDouble(),
      yieldScore: (json['yield_score'] ?? 0).toDouble(),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'composite_score': compositeScore,
      'condition_match': conditionMatch,
      'yield_score': yieldScore,
      '_id': id,
    };
  }
}

List<FieldData> parseFieldData(String jsonStr) {
  final jsonData = json.decode(jsonStr);
  return (jsonData['fields'] as List?)
          ?.map((item) => FieldData.fromJson(item))
          .toList() ??
      [];
}

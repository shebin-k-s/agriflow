import 'package:agriflow/domain/entities/recommendation/crop_recommendation.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit() : super(RecommendationLoading());

  void loadRecommendation() {
    final List<CropRecommendationEntity> recommendations = [
      CropRecommendationEntity(
        fieldName: 'Field 1',
        crops: [
          Crops(
              cropName: 'Cotton',
              percentage: 95,
              description: 'Ideal soil pH and moisture'),
          Crops(
              cropName: 'Wheat',
              percentage: 85,
              description: 'Good nitrogen levels'),
          Crops(
              cropName: 'Soybeans',
              percentage: 75,
              description: 'Suitable soil texture'),
        ],
      ),
      CropRecommendationEntity(
        fieldName: 'Field 2',
        crops: [
          Crops(
              cropName: 'Corn',
              percentage: 90,
              description: 'Based on current soil condition'),
          Crops(
              cropName: 'Rice',
              percentage: 80,
              description: 'Based on current soil condition'),
          Crops(
              cropName: 'Wheat',
              percentage: 70,
              description: 'Based on current soil condition'),
        ],
      ),
      CropRecommendationEntity(
        fieldName: 'Field 3',
        crops: [
          Crops(
              cropName: 'Soybeans',
              percentage: 92,
              description: 'Based on current soil condition'),
          Crops(
              cropName: 'Cotton',
              percentage: 82,
              description: 'Based on current soil condition'),
          Crops(
              cropName: 'Corn',
              percentage: 72,
              description: 'Based on current soil condition'),
        ],
      ),
    ];

    emit(
      RecommendationLoaded(recommendation: recommendations),
    );
  }
}

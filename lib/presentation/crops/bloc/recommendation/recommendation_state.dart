part of 'recommendation_cubit.dart';

@immutable
sealed class RecommendationState {}

final class RecommendationLoading extends RecommendationState {}

class RecommendationLoaded extends RecommendationState{
  final List<CropRecommendationEntity> recommendation;

  RecommendationLoaded({required this.recommendation});
}

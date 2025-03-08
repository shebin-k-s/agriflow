part of 'fields_cubit.dart';

@immutable
sealed class FieldsState {}

final class FieldsLoading extends FieldsState {}

class FieldsLoaded extends FieldsState {
  final List<FieldData> fields;
  FieldsLoaded({
    required this.fields,
  });
}

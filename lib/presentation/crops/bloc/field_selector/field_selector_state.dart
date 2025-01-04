part of 'field_selector_cubit.dart';

@immutable
sealed class FieldSelectorState {}

 class FieldSelector extends FieldSelectorState {
  final int selectedIndex;

  FieldSelector({required this.selectedIndex});

}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'field_selector_state.dart';

class FieldSelectorCubit extends Cubit<FieldSelectorState> {
  FieldSelectorCubit() : super(FieldSelector(selectedIndex: 0));

  void selectField(int index) {
    emit(
      FieldSelector(selectedIndex: index),
    );
  }
}

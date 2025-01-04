import 'package:agriflow/domain/entities/field/field.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fields_state.dart';

class FieldsCubit extends Cubit<FieldsState> {
  FieldsCubit() : super(FieldsLoading());

  void loadFields() {
    final List<FieldEntity> fields = [
      FieldEntity(
        fieldName: 'Field 1',
        currentCrop: 'Cotton',
        moisture: 75,
        temperature: 25,
        pH: 6.5,
        nitrogen: 45,
        phosphorus: 35,
        potassium: 40,
        deviceId: 'DEV001',
      ),
      FieldEntity(
        fieldName: 'Field 2',
        currentCrop: 'Wheat',
        moisture: 65,
        temperature: 23,
        pH: 6.8,
        nitrogen: 50,
        phosphorus: 30,
        potassium: 45,
        deviceId: 'DEV002',
      ),
      FieldEntity(
        fieldName: 'Field 3',
        currentCrop: 'Rice',
        moisture: 80,
        temperature: 26,
        pH: 6.2,
        nitrogen: 55,
        phosphorus: 40,
        potassium: 50,
        deviceId: 'DEV003',
      ),
    ];

    emit(
      FieldsLoaded(fields: fields),
    );
  }
}

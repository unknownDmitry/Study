import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab6/requests/api.dart';

import 'nasa_state.dart';
import 'package:lab6/models/nasa.dart';

class NasaCubit extends Cubit<NasaState> {
  NasaCubit() : super(NasaLoadingState());

  Future<void> loadData() async {
    try {
      Map<String, dynamic> apiData = await getNasaData();
      Nasa nasaData = Nasa.fromJson(apiData);
      emit(NasaLoadedState(data: nasaData));
      return;
    } catch (e) {
      emit(NasaErrorState());
      return;
    }
  }
}

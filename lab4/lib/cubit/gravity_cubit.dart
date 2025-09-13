import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'gravity_state.dart';

class GravityCubit extends Cubit<GravityState> {
  GravityCubit() : super(GravityInitial());

  void calculateGravity(double mass, double radius) {
    emit(GravityLoading());

    try {
      const double G = 6.67430e-11;
      final acceleration = G * mass / (radius * radius);

      emit(
        GravityCalculated(
          mass: mass,
          radius: radius,
          acceleration: acceleration,
        ),
      );
    } catch (e) {
      emit(GravityError('Ошибка расчета: $e'));
    }
  }

  void reset() {
    emit(GravityInitial());
  }
}

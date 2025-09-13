import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class DewPointCubit extends Cubit<double> {
  DewPointCubit() : super(0.0);

  double calculateDewPoint({
    required double temperature,
    required double humidity,
  }) {
    // Формула для расчета точки росы (формула Магнуса)
    // Td = T - ((100 - RH) / 5)
    // где Td - точка росы, T - температура, RH - относительная влажность

    // Более точная формула:
    // Td = (b * α(T,RH)) / (a - α(T,RH))
    // где α(T,RH) = ((a * T) / (b + T)) + ln(RH/100)
    // a = 17.27, b = 237.7°C

    const double a = 17.27;
    const double b = 237.7;

    double alpha = (a * temperature) / (b + temperature) +
        log((humidity / 100).clamp(0.01, 1.0));
    double dewPoint = (b * alpha) / (a - alpha);

    emit(dewPoint);
    return dewPoint;
  }
}

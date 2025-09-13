part of 'gravity_cubit.dart';

@immutable
abstract class GravityState {}

class GravityInitial extends GravityState {}

class GravityLoading extends GravityState {}

class GravityCalculated extends GravityState {
  final double mass;
  final double radius;
  final double acceleration;

  GravityCalculated({
    required this.mass,
    required this.radius,
    required this.acceleration,
  });
}

class GravityError extends GravityState {
  final String message;

  GravityError(this.message);
}

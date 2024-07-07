import 'package:equatable/equatable.dart';

class PointLatLng extends Equatable {
  final double latitude;
  final double longitude;

  const PointLatLng(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

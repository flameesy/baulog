import 'package:equatable/equatable.dart';
import '../../core/models/facility_model.dart';

abstract class FacilityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFacilities extends FacilityEvent {}

class AddFacility extends FacilityEvent {
  final Facility facility;
  AddFacility(this.facility);

  @override
  List<Object?> get props => [facility];
}

class UpdateFacility extends FacilityEvent {
  final Facility facility;
  UpdateFacility(this.facility);

  @override
  List<Object?> get props => [facility];
}

class DeleteFacility extends FacilityEvent {
  final int id;
  DeleteFacility(this.id);

  @override
  List<Object?> get props => [id];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/facility_service.dart';
import 'facility_events.dart';
import 'facility_state.dart';

class FacilityBloc extends Bloc<FacilityEvent, FacilityState> {
  final FacilityService facilityService;

  FacilityBloc(this.facilityService) : super(FacilityInitial()) {
    on<LoadFacilities>((event, emit) async {
      emit(FacilityLoading());
      try {
        final facilities = await facilityService.getAllFacilities();
        emit(FacilityLoaded(facilities));
      } catch (e) {
        emit(FacilityError("Failed to load facilities"));
      }
    });

    on<AddFacility>((event, emit) async {
      try {
        await facilityService.addFacility(event.facility);
        add(LoadFacilities());
      } catch (e) {
        emit(FacilityError("Failed to add facility"));
      }
    });

    on<UpdateFacility>((event, emit) async {
      try {
        await facilityService.updateFacility(event.facility);
        add(LoadFacilities());
      } catch (e) {
        emit(FacilityError("Failed to update facility"));
      }
    });

    on<DeleteFacility>((event, emit) async {
      try {
        await facilityService.deleteFacility(event.id);
        add(LoadFacilities());
      } catch (e) {
        emit(FacilityError("Failed to delete facility"));
      }
    });
  }
}

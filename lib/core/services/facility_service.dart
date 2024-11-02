import '../models/facility_model.dart';
import '../../core/services/service_base.dart';

class FacilityService {
  final ServiceBase _databaseHelper = ServiceBase();

  FacilityService();

  Future<List<Facility>> getAllFacilities() async {
    final List<Map<String, dynamic>> facilities = await _databaseHelper.getRecords(table: 'facility');
    return facilities.map((facility) => Facility.fromMap(facility)).toList();
  }

  Future<void> addFacility(Facility facility) async {
    await _databaseHelper.insertRecord(
      table: 'facility',
      fields: 'name, location, description', // Passen Sie die Felder an Ihr Facility-Modell an
      values: [facility.name, facility.location, facility.description],
    );
  }

  Future<void> updateFacility(Facility facility) async {
    await _databaseHelper.updateRecord(
      table: 'facility',
      fields: 'name, location, description', // Passen Sie die Felder an Ihr Facility-Modell an
      values: [facility.name, facility.location, facility.description],
      where: 'id = ?',
      whereArgs: [facility.id],
    );
  }

  Future<void> deleteFacility(int id) async {
    await _databaseHelper.deleteRecord(
      table: 'facility',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

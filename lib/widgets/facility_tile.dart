import 'package:flutter/material.dart';
import '../core/models/facility_model.dart';

class FacilityTile extends StatelessWidget {
  final Facility facility;
  final VoidCallback onTap;

  FacilityTile({required this.facility, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(facility.name),
      subtitle: Text(facility.type),
      trailing: Text(facility.status),
      onTap: onTap,
    );
  }
}

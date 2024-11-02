import 'package:flutter/material.dart';
import '../../core/models/facility_model.dart';

class FacilityDetailPage extends StatelessWidget {
  final Facility facility;

  FacilityDetailPage({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(facility.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type: ${facility.type}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Status: ${facility.status}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

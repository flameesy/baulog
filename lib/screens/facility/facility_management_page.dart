import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/facility_bloc.dart';
import '../../bloc/facility_events.dart';
import '../../bloc/facility_state.dart';
import '../../widgets/facility_tile.dart';
import 'facility_detail_page.dart';

class FacilityManagementPage extends StatefulWidget {
  const FacilityManagementPage({Key? key}) : super(key: key);

  @override
  _FacilityManagementPageState createState() => _FacilityManagementPageState();
}

class _FacilityManagementPageState extends State<FacilityManagementPage> {
  @override
  void initState() {
    super.initState();
    // Lade die Facilities beim Start
    BlocProvider.of<FacilityBloc>(context).add(LoadFacilities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FacilityBloc, FacilityState>(
        builder: (context, state) {
          if (state is FacilityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FacilityLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.facilities.length,
                    itemBuilder: (context, index) {
                      final facility = state.facilities[index];
                      return FacilityTile(
                        facility: facility,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FacilityDetailPage(facility: facility),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FacilityError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No facilities available"));
          }
        },
      ),
    );
  }
}

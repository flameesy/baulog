import 'package:flutter/material.dart';
import 'package:baulog/routes/routes.dart';
import 'package:baulog/themes/colors.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List sideNav = [
      {'name': 'News', 'path': Routes.news},
      {'name': 'About', 'path': Routes.about},
      {'name': 'Appointments', 'path': Routes.appointments},
      {'name': 'Facilities', 'path': Routes.facilities},
    ];
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        color: AppColors.primary,
        child: Column(
          children: [
            // Header with logo
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary, // Matches the drawer background color
              ),
              child: Container(
                width: 100,
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/logo.png'), // Your logo
              ),
            ),
            // List of navigation items
            Expanded(
              child: ListView.builder(
                itemCount: sideNav.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      Navigator.pushNamed(context, sideNav[index]['path']),
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            sideNav[index]['name'],
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(color: AppColors.white),
                          ),
                        ),
                        Divider(
                          color: AppColors.primaryLight,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

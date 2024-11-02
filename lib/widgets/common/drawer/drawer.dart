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
    return new Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        color: AppColors.primary,
        child: new ListView.builder(
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
                    child: new Text(
                      sideNav[index]['name'],
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: AppColors.white),
                    ),
                  ),
                  new Divider(
                    color: AppColors.primaryLight,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

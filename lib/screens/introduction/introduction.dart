import 'package:flutter/material.dart';
import 'package:baulog/resources/images.dart';
import 'package:baulog/resources/strings.dart';
import 'package:baulog/routes/routes.dart';
import 'package:baulog/themes/colors.dart';
import 'package:baulog/utils/navigations.dart';
import 'package:baulog/widgets/common/buttons/primary_button.dart';

/// [IntroductionScreen] is the intro screen that loads into the app.
/// it should load only once for new uesr

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(Images.INTRO_IMG),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(25, 40, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Strings.INTRO_TITLE,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        Strings.INTRO_LIST_TITLE,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: Strings.INTRO_LIST.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryDark,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      Strings.INTRO_LIST[index],
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: PrimaryButton(
                          text: Strings.GET_STARTED,
                          onPressed: () =>
                              Navigation.pushNamed(context, Routes.news),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

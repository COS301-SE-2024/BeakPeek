import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/UserProfile/user_profile_function.dart';
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:progress_bar_chart/progress_bar_chart.dart';

Widget getNumBirdsInProvAndLifeList(
    List<int> birdNumsTotal, Future<List<Bird>> birds) {
  return FutureBuilder<List<Bird>>(
    future: birds,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      return Column(children: [
        Text(birdNumsTotal.toString()),
        Text(
          snapshot.data!.toString(),
        )
      ]);
    },
  );
}

Widget levelProgressBar() {
  final List<StatisticsItem> colors = [
    StatisticsItem(const Color.fromARGB(255, 238, 203, 135),
        (user.xp / getNextLevelExpRequired(user.level) * 100),
        title: 'Exp'),
    StatisticsItem(
        const Color(0xffecad31),
        ((getNextLevelExpRequired(user.level) - user.xp).toDouble() /
                getNextLevelExpRequired(user.level) *
                100)
            .toDouble(),
        title: 'Need Exp')
  ];
  return ProgressBarChart(
    values: colors,
    height: 30,
    totalPercentage: 100,
    borderRadius: 20,
    unitLabel: 'Exp',
  );
}

Widget progressBars(List<int> birdNumsTotal, List<int> numbirdsInLife) {
  return SingleChildScrollView(
    child: SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          final String prov = provinces[index];
          final String formattedProv = formatProvinceName(prov);
          final double percentage =
              getPercent(birdNumsTotal[index], numbirdsInLife[index]);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Text(
                  formattedProv,
                  style: GlobalStyles.contentPrimary(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FAProgressBar(
                      currentValue: percentage,
                      backgroundColor: AppColors.popupColor(context),
                      progressColor: AppColors.tertiaryColor(context),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: GlobalStyles.contentPrimary(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

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

Widget levelProgressBar(BuildContext context) {
  final double progressPercentage =
      user.xp / getNextLevelExpRequired(user.level);

  final String xpLabel = '${user.xp}/${getNextLevelExpRequired(user.level)} XP';

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        height: 30,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 225, 204),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 30,
          width: MediaQuery.of(context).size.width * progressPercentage,
          decoration: BoxDecoration(
            color: const Color(0xffecad31),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      Text(
        xpLabel,
        style: GlobalStyles.contentPrimary(context).copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor(context),
          fontSize: 16,
        ),
      ),
    ],
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

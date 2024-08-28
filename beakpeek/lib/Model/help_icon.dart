import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/Model/help_icon_model_functions.dart';

class HelpIcon extends StatelessWidget {
  const HelpIcon({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showHelpPopup(context, content);
      },
      child: const Icon(
        Icons.help_outline,
        size: 30.0,
        color: AppColors.secondaryColorLight,
      ),
    );
  }
}

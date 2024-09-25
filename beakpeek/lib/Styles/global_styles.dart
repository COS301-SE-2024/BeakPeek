import 'package:flutter/material.dart';
import 'package:beakpeek/Styles/colors.dart';

abstract class GlobalStyles {
  // -------------------------- Large heading styles -------------------------- //

  static TextStyle mainHeadingPrimary(BuildContext context) {
    return TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        fontFamily: 'SF Pro Display',
        color: AppColors.primaryColor(context));
  }

  static TextStyle mainHeadingSecondary(BuildContext context) {
    return TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        fontFamily: 'SF Pro Display',
        color: AppColors.secondaryColor(context));
  }

  static TextStyle mainHeadingTertiary(BuildContext context) {
    return TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        fontFamily: 'SF Pro Display',
        color: AppColors.tertiaryColor(context));
  }

  // -------------------------- Medium heading styles -------------------------- //

  static TextStyle subHeadingPrimary(BuildContext context) {
    return TextStyle(
        fontSize: 32,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor(context));
  }

  static TextStyle subHeadingSecondary(BuildContext context) {
    return TextStyle(
        fontSize: 32,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryColor(context));
  }

  static TextStyle subHeadingTertiary(BuildContext context) {
    return TextStyle(
        fontSize: 32,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        color: AppColors.tertiaryColor(context));
  }

  // -------------------------- Small heading styles -------------------------- //

  static TextStyle smallHeadingPrimary(BuildContext context) {
    return TextStyle(
        fontSize: 20,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor(context));
  }

  static TextStyle smallHeadingSecondary(BuildContext context) {
    return TextStyle(
        fontSize: 20,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryColor(context));
  }

  static TextStyle smallHeadingTertiary(BuildContext context) {
    return TextStyle(
        fontSize: 20,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryColor(context));
  }

  // -------------------------- Small content styles -------------------------- //

  static TextStyle contentPrimary(BuildContext context) {
    return TextStyle(
        fontSize: 17,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w500,
        color: AppColors.textColor(context));
  }

  static TextStyle smallContentPrimary(BuildContext context) {
    return TextStyle(
        fontSize: 15,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w400,
        color: AppColors.textColor(context));
  }

  static TextStyle contentSecondary(BuildContext context) {
    return TextStyle(
        fontSize: 17,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryColor(context));
  }

  static TextStyle contentTertiary(BuildContext context) {
    return TextStyle(
        fontSize: 17,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w500,
        color: AppColors.tertiaryColor(context));
  }

  static TextStyle smallContent(BuildContext context) {
    return TextStyle(
        fontSize: 17,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w500,
        color: AppColors.greyColor(context));
  }

  static TextStyle contentBold(BuildContext context) {
    return TextStyle(
        fontSize: 17,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.bold,
        color: AppColors.textColor(context));
  }

  // -------------------------- Button styles -------------------------- //

  static ButtonStyle buttonPrimaryFilled(BuildContext context) {
    return FilledButton.styleFrom(
      side: BorderSide(color: AppColors.primaryButtonColor(context)),
      backgroundColor: AppColors.primaryButtonColor(context),
      minimumSize: const Size(350, 50),
      elevation: 20,
    );
  }

  static ButtonStyle buttonPrimaryOutlined(BuildContext context) {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.primaryButtonColor(context)),
      backgroundColor: Colors.transparent,
      minimumSize: const Size(350, 50),
    );
  }

  static ButtonStyle buttonSecondaryFilled(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.secondaryColor(context),
      minimumSize: const Size(350, 50),
      elevation: 10,
    );
  }

  static ButtonStyle buttonSecondaryOutlined(BuildContext context) {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.secondaryColor(context)),
      backgroundColor: Colors.transparent,
      minimumSize: const Size(350, 50),
    );
  }

  // -------------------------- Button text styles -------------------------- //

  static TextStyle primaryButtonText(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      color: AppColors.primaryButtonTextColor(context),
    );
  }

  static TextStyle secondaryButtonText(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryButtonTextColor(context),
    );
  }

  //-----------------------Search Styles------------------//
  static TextStyle filterTileHeading(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      color: AppColors.filterColor(context),
    );
  }

  static TextStyle filterTileSubHeading(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      color: AppColors.greyColor(context),
    );
  }

  static ButtonStyle buttonFilterPrimaryFilled(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.popupColor(context),
      minimumSize: const Size(128, 30),
      elevation: 10,
    );
  }
}

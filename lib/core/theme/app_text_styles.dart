import 'package:flutter/material.dart';
import 'package:perpusku/core/theme/app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle bookTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.3,
  );
  static const TextStyle bookAuthor = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: 0.8,
    height: 1.3,
  );
  static const TextStyle bookYear = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.3,
  );
  static const TextStyle bookRating = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    height: 1.3,
  );
  static TextStyle splashInitializing = TextStyle(
    fontSize: 14,
    color: AppColors.white,
    letterSpacing: 1,
  );
  static TextStyle appHeaderTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static TextStyle appHeaderSkipText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );
  static TextStyle onBoardingTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static TextStyle onBoardingSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );
  static TextStyle buttonStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

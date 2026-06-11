import 'package:flutter/material.dart';

class AppColors {

  static const background = Color(0xFFF8FAFC);

  static const white = Color(0xFFFFFFFF);

  static const black = Color(0xFF222222);

  static const darkBlue = Color(0xFF003F87);
  static const lightBlue = Color(0xFF2F73D2);
  static const extraLightBlue = Color(0xFF1677FF);
  static const blue = Color(0xFF4086F4); 

  static const yellow = Color(0xFFE0BD00);
  static const backgroundYellow = Color(0xFFFFFBE6);
  static const lightYellow = Color(0xFFFFCF66); 

  static const green = Color(0xFF52C41A);
  static const backgroundGreen = Color(0xFFF6FFED);
  static const darkGreen = Color(0xFF00733B);  

  static const red = Color(0xFFFF4D4F);
  static const backgroundRed = Color(0xFFFFF2F0);
  static const darkRed = Color(0xFFE5252A); 

  static const grey = Color(0xFF9CA3AF);
  static const backgroundGrey = Color(0xFFF8FAFC);
 
}
 
 class AppTextStyles {

  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.darkBlue,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static const TextStyle title1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C323F),
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlue,
  );


  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF2C323F),
  );

  static const TextStyle subtitle3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlue
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBlue,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

  static const TextStyle body3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
  );

   static const TextStyle body4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C323F),
  );

  static const TextStyle button1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle button2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle navText1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF003F87),
  );

  static const TextStyle navText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF9CA3AF),
  );

  static const TextStyle caption1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
  );

  static const TextStyle label1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B7280),
  );

  static const TextStyle label2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

   static const TextStyle label3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlue,
  );

  static const TextStyle statusApproved = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF52C41A),
  );

  static const TextStyle statusPending = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFAAD14),
  );

  static const TextStyle statusRejected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFF4D4F),
  );
}


class AppIconsSize {
  static const double iconS = 18;
  static const double iconM = 24;
  static const double iconL = 32;
}


ThemeData appTheme = ThemeData(
  fontFamily: 'KantumruyPro',
  scaffoldBackgroundColor: AppColors.white,
);


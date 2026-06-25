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
  static const darkGray = Color(0xFF6B7280);
  static const backgroundGrey = Color(0xFFF8FAFC);

}

class AppTextStyles {

    static final TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static final TextStyle heading2 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.darkBlue,
  );

  static final TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle heading4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

static final TextStyle title1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle title2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C323F),
  );

  static final TextStyle title3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlue,
  );

  static final TextStyle title4 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle title5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );


  
  static final TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.grey,
  );

  static final TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C323F),
  );

  static final TextStyle subtitle3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlue,
  );

  static final TextStyle subtitle4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle subtitle5 = TextStyle(
    fontSize: 15,
    color: Color(0xFF8A92A6),
    fontWeight: FontWeight.w400,
  );


  static final TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBlue,
  );

  static final TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

  static final TextStyle body3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
  );

  static final TextStyle body4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF2C323F),
  );

  static final TextStyle body5 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9E9E9E),
  );

  static final TextStyle body6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C323F),
  );



  static final TextStyle button1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  static final TextStyle button2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  

  static final TextStyle navText1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF003F87),
  );

  static final TextStyle navText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF9CA3AF),
  );

    static final TextStyle caption1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

  static final TextStyle caption2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
  );

  static final TextStyle caption3 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static final TextStyle label1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
  );

  static final TextStyle label2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9CA3AF),
  );

  static final TextStyle label3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlue,
  );

  static final TextStyle label4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 97, 101, 107),
  );

  static final TextStyle label5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 85, 88, 94),
  );


static final TextStyle statusApproved = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF52C41A),
  );

  static final TextStyle statusPending = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFAAD14),
  );

  static final TextStyle statusRejected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFF4D4F),
  );
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Kantumruy',
  scaffoldBackgroundColor: AppColors.white,

);

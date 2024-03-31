import 'package:flutter/material.dart';

//Custom Colors
const Color lightSecondaryColor = Color(0xff0c0c93); // Color(0xff196E55);
//const Color lightPrimaryColor = Color(0xffbd2121);
//const Color lightPrimaryColor = Color(0xff707070);
const Color lightPrimaryColor = Color.fromARGB(255, 171, 166, 166);
const Color lightScaffoldColor = Color(0xffffffff);

const Color darkPrimaryColor = Color(0xffF4863C);
const Color darkSecondaryColor = Color(0xffF5A921);
const Color darkScaffoldColor = Color(0xff191919);

const Color darkBlueColor = Color(0xff31446C);
const Color greyColor = Color(0xff999999);
const Color whiteColor = Color(0xffFAFAFA);
const Color blackColor = Color(0xff191919);
const Color errorColor = Colors.red;

TextStyle getBoldTextStyle = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  fontFamily: "Poppins-Bold",
  color: Colors.black,
);
TextStyle getDefaultTextStyle = const TextStyle(
  fontSize: 15,
  fontFamily: "Poppins-Regular",
  color: whiteColor,
);
TextStyle getSubtitleTextStyle = TextStyle(
  fontFamily: "Poppins-Regular",
  fontSize: 13,
  color: whiteColor.withOpacity(.9),
);

class CustomTheme {
  final customLightTheme = ThemeData(
    primaryColor: lightSecondaryColor,
    scaffoldBackgroundColor: lightScaffoldColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimaryColor,
      onPrimary: whiteColor,
      secondary: lightSecondaryColor,
      onSecondary: whiteColor,
      error: errorColor,
      onError: whiteColor,
      background: lightScaffoldColor,
      onBackground: whiteColor,
      surface: lightPrimaryColor,
      onSurface: blackColor,
    ),
    textTheme: TextTheme(
        headline5: getBoldTextStyle.copyWith(
          color: blackColor,
        ),
        headline1: getBoldTextStyle.copyWith(
          color: blackColor,
        )),
  );

  final customDarkTheme = ThemeData(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkScaffoldColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimaryColor,
      onPrimary: whiteColor,
      secondary: darkSecondaryColor,
      onSecondary: darkSecondaryColor,
      error: errorColor,
      onError: errorColor,
      background: darkScaffoldColor,
      onBackground: darkScaffoldColor,
      surface: darkPrimaryColor,
      onSurface: whiteColor,
    ),
    textTheme: TextTheme(
      headline5: getBoldTextStyle.copyWith(
        color: blackColor,
      ),
    ),
  );
}

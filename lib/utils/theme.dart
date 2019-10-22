import 'package:flutter/material.dart';

final logo = new Image.asset('assets/logo.png', height: 128.0);
final logo_web = new Image.asset('logo.png', height: 128.0);
final ThemeData customLightTheme = _buildTheme();
final title = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: dark, );
final subtitle = TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: grey_dark);
const title_rev = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: white, );
final subtitle_rev = TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: grey_light);
final error = TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: red);
final label = TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: dark);
final label_rev = TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: white);
final orario_card = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: white, );
final button_card = TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: white, );
final dayWaitingEvent = TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: dark );
final datWaitingEvent = TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: grey );
final Text12WhiteNormal = TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: white );

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Color(0xFFC5032B), //Colore secondario <-- da sistemare quando compare
    primaryColor: dark, //appBar
    scaffoldBackgroundColor: whitebackground, //ok
    cardColor: Color(0x00000000),
    textSelectionColor: Color(0xFFC5032B),
    cursorColor: Color(0xFFFFFFFF),
    errorColor: red,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Color(0xFF333333),
      textTheme: ButtonTextTheme.normal
    ),
    hintColor: grey_light,
    buttonColor: Color(0xFFC5032B),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        fillColor: Color(0xFFC5032B),

  ),
    textTheme: _buildShrineTextTheme(base.textTheme,dark), //ok
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme,Color(0xFFFFFFFF)), //text appBar
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme,Color(0xFFC5032B)), //Colore secondario <-- da sistemare quando compare
    iconTheme: IconThemeData(color: Color(0xFFF4F4F4)), //dunno
    primaryIconTheme: IconThemeData(color: Color(0xFFFFFFFF)) //icon
  );
}

TextTheme _buildShrineTextTheme(TextTheme base, Color c) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    body2: base.body2.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Roboto',
    displayColor: Color(0xFFC5032B), //dunno
    bodyColor: c, //text

  );
}

const dark = const Color(0xFF333333);
const almost_dark = const Color(0xFF4b4b4b);
const grey_dark = const Color(0xFFA8A8A8);
const grey = const Color(0xFFA3A3A3);
const grey_light = const Color(0xFFF4F4F4);
const white = const Color(0xFFFFFFFF);
const whitebackground = const Color(0xFFFFFFFF);
const whiteoverlapbackground = const Color(0x99FFFFFF);
const red = const Color(0xFFC5032B);
const yellow = const Color(0xFFF8AD09);
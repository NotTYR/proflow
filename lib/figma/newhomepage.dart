import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:ProFlow/utils.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // homepagembL (3:10)
        padding: EdgeInsets.fromLTRB(123*fem, 163*fem, 33*fem, 44*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // logo5tr (18:47)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 90*fem, 21*fem),
              width: 178*fem,
              height: 178*fem,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              // proflownYN (18:46)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 90*fem, 40*fem),
              child: Text(
                'Proflow',
                style: SafeGoogleFont (
                  'Inter',
                  fontSize: 36*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125*ffem/fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              // autogroupopja3z6 (XSVUkmhHeLbhbqoiacopJa)
              margin: EdgeInsets.fromLTRB(9*fem, 0*fem, 103*fem, 15*fem),
              width: double.infinity,
              height: 67*fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // mentorfindingplatform9XL (12:13)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 28*fem, 0*fem),
                    padding: EdgeInsets.fromLTRB(22*fem, 22*fem, 21*fem, 21*fem),
                    height: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xff3874cb),
                      borderRadius: BorderRadius.circular(33.5*fem),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0*fem, 4*fem),
                          blurRadius: 2*fem,
                        ),
                      ],
                    ),
                    child: Center(
                      // searchD1Q (12:4)
                      child: SizedBox(
                        width: 24*fem,
                        height: 24*fem,
                        child: Image.asset(
                          'assets/search.png',
                          width: 24*fem,
                          height: 24*fem,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // myprojectXAW (12:14)
                    padding: EdgeInsets.fromLTRB(22*fem, 27*fem, 21*fem, 26.67*fem),
                    height: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xff3874cb),
                      borderRadius: BorderRadius.circular(33.5*fem),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0*fem, 4*fem),
                          blurRadius: 2*fem,
                        ),
                      ],
                    ),
                    child: Center(
                      // listpfQ (12:9)
                      child: SizedBox(
                        width: 24*fem,
                        height: 13.33*fem,
                        child: Image.asset(
                          'assets/list.png',
                          width: 24*fem,
                          height: 13.33*fem,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupk5ewYbQ (XSVUzBUcLDec8JzkDDk5EW)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 105.5*fem, 25*fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // mentorfindingplatformfvv (12:33)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 21.5*fem, 0*fem),
                    constraints: BoxConstraints (
                      maxWidth: 86*fem,
                    ),
                    child: Text(
                      'Mentor Finding Platform',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont (
                        'Inter',
                        fontSize: 12*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2125*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    // myproject9r6 (12:39)
                    'My Project',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 12*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupdzsgtog (XSVV7G79TDwdZQLygUDzsG)
              margin: EdgeInsets.fromLTRB(8*fem, 0*fem, 103*fem, 15*fem),
              width: double.infinity,
              height: 67*fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // textvoicechannelpBY (12:32)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 29*fem, 0*fem),
                    width: 67*fem,
                    height: 67*fem,
                    child: Image.asset(
                      'assets/text-voice-channel.png',
                      width: 67*fem,
                      height: 67*fem,
                    ),
                  ),
                  Container(
                    // forumiGv (12:15)
                    padding: EdgeInsets.fromLTRB(23.08*fem, 24.08*fem, 23.08*fem, 22.08*fem),
                    height: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xff3874cb),
                      borderRadius: BorderRadius.circular(33.5*fem),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0*fem, 4*fem),
                          blurRadius: 2*fem,
                        ),
                      ],
                    ),
                    child: Center(
                      // vectorDUa (12:12)
                      child: SizedBox(
                        width: 20.83*fem,
                        height: 20.83*fem,
                        child: Image.asset(
                          'assets/vector.png',
                          width: 20.83*fem,
                          height: 20.83*fem,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroup2j4a8rS (XSVVE6F6irPcDFrjP62j4A)
              margin: EdgeInsets.fromLTRB(13*fem, 0*fem, 118*fem, 126*fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // textvoicechannelGBx (12:38)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 47*fem, 0*fem),
                    constraints: BoxConstraints (
                      maxWidth: 60*fem,
                    ),
                    child: Text(
                      'Text/Voice Channel',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont (
                        'Inter',
                        fontSize: 12*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2125*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    // forum9Fk (12:37)
                    'Forum',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 12*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // logoutbutton5QJ (8:4)
              margin: EdgeInsets.fromLTRB(207*fem, 0*fem, 0*fem, 0*fem),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom (
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(22*fem, 22*fem, 21*fem, 21*fem),
                  decoration: BoxDecoration (
                    color: Color(0xff3874cb),
                    borderRadius: BorderRadius.circular(33.5*fem),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        offset: Offset(0*fem, 4*fem),
                        blurRadius: 2*fem,
                      ),
                    ],
                  ),
                  child: Center(
                    // logoutY2z (8:3)
                    child: SizedBox(
                      width: 24*fem,
                      height: 24*fem,
                      child: Image.asset(
                        'assets/logout.png',
                        width: 24*fem,
                        height: 24*fem,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          );
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

class SignInLight extends StatelessWidget {
  const SignInLight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFEEEEEB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 75,
                top: 72,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0)..rotateZ(0),
                  child: Container(
                    width: 334,
                    height: 469,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logIn.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 54,
                top: 759,
                child: SizedBox(
                  width: 286,
                  height: 30,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don’t have an account? ',
                          style: TextStyle(
                            color: Color(0xB2033A30),
                            fontSize: 14,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Color(0xFFBC1921),
                            fontSize: 14,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                left: 207,
                top: 704,
                child: Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 35.28,
                          height: 36,
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 151,
                top: 704,
                child: Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const FlutterLogo(),
                ),
              ),
              Positioned(
                left: 48,
                top: 672,
                child: SizedBox(
                  width: 303,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 203,
                        top: 9,
                        child: Container(
                          width: 100,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0x4C1E1E1E),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 9,
                        child: Container(
                          width: 100,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0x4C1E1E1E),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 38,
                        top: 0,
                        child: SizedBox(
                          width: 225,
                          height: 22,
                          child: Text(
                            'or sign in with',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xB200383E),
                              fontSize: 14,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 48,
                top: 603,
                child: SizedBox(
                  width: 304,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 304,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF033A30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F737373),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 304,
                          height: 48,
                          child: Text(
                            'Sign in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w500,
                              height: 2.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 48,
                top: 541,
                child: SizedBox(
                  width: 304,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 304,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEEEEEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F737373),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 18,
                        top: 0,
                        child: SizedBox(
                          width: 285,
                          height: 48,
                          child: TextField(
                            style: TextStyle(
                              color: Color(0x9900383E),
                              fontSize: 16,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Color(0x9900383E),
                                fontSize: 16,
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 47,
                top: 479,
                child: SizedBox(
                  width: 304,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 304,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEEEEEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F737373),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 19,
                        top: 0,
                        child: SizedBox(
                          width: 285,
                          height: 48,
                          child: TextField(
                            style: TextStyle(
                              color: Color(0x9900383E),
                              fontSize: 16,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Email address',
                              hintStyle: TextStyle(
                                color: Color(0x9900383E),
                                fontSize: 16,
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 47,
                top: 426,
                child: SizedBox(
                  width: 120,
                  height: 43,
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00383E),
                      fontSize: 32,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 113,
                top: 144,
                child: SizedBox(
                  width: 260,
                  height: 86,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome\n',
                          style: TextStyle(
                            color: Color(0xFFF97142),
                            fontSize: 36,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'Back!',
                          style: TextStyle(
                            color: Color(0xFF00383E),
                            fontSize: 36,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:beakpeek/sign_up.dart';
import 'package:beakpeek/log_in.dart';

class LandingTab2Light extends StatelessWidget {
  const LandingTab2Light(this.signin, this.login, {super.key});

  final void Function() signin;
  final void Function() login;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFF0ECE6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 459,
                child: Container(
                  width: 393,
                  height: 393,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/landing2.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 831,
                child: SizedBox(
                  width: 393,
                  height: 21,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 266,
                        top: 8,
                        child: Transform(
                          // ignore: duplicate_ignore
                          // ignore: lines_longer_than_80_chars
                          transform: Matrix4.identity()
                            ..translate(0.0)
                            ..rotateZ(3.14),
                          child: Container(
                            width: 139,
                            height: 5,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 787,
                child: SizedBox(
                  width: 393,
                  height: 44,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 172,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF0D0D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.30,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: ShapeDecoration(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 471,
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
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 304,
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: Colors.blue, // Change the color to match your design
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the border radius as needed
                              ),
                              child: const Text(
                                'Sign Up',
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 45,
                top: 405,
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
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xFF033A30)),
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
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 304,
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInLight()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: Colors.blue, // Change the color to match your design
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the border radius as needed
                              ),
                              child: const Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF033A30),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  height: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 45,
                top: 324,
                child: SizedBox(
                  width: 332,
                  height: 49,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Create an account or sign in \nto join the ',
                          style: TextStyle(
                            color: Color(0xB200383E),
                            fontSize: 20,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'BeakPeek',
                          style: TextStyle(
                            color: Color(0xFFCE7625),
                            fontSize: 20,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: ' community.',
                          style: TextStyle(
                            color: Color(0xB200383E),
                            fontSize: 20,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 45,
                top: 158,
                child: SizedBox(
                  width: 194,
                  height: 144,
                  child: Text(
                    'Explore, Discover,\nand Share',
                    style: TextStyle(
                      color: Color(0xFF00532D),
                      fontSize: 40,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

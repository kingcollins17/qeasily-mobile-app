// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/db/db.dart';
import 'package:qeasily/screen/screen.dart';
import 'package:qeasily/styles.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with Ui {
  final controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            child: PageView(
              controller: controller,
              onPageChanged: (value) => setState(() {
                currentIndex = value;
              }),
              children: [
                ...List.generate(
                    onboards.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Expanded(
                                child: SvgPicture.asset(
                                  onboards[index].imageUrl,
                                  fit: BoxFit.fill,
                                  // width: MediaQuery.of(context).size.width * 0.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(onboards[index].title, style: big00),
                              const SizedBox(height: 20),
                              Text(
                                onboards[index].content,
                                textAlign: TextAlign.center,
                                style: mukta,
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    onboards.length,
                    (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: AnimatedContainer(
                          width: index == currentIndex ? 15 : 8,
                          height: index == currentIndex ? 15 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentIndex
                                ? jungleGreen
                                : Colors.grey,
                          ),
                          duration: Duration(milliseconds: 300),
                        )))
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () {
                controller.animateToPage(++currentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
                if (currentIndex >= onboards.length) {
                  // push(LoginScreen(), context);
                  context.push('/login');
                }
              },
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  fixedSize: MaterialStatePropertyAll(
                    Size(MediaQuery.of(context).size.width * 0.8, 45),
                    
                  ),
                  backgroundColor: MaterialStatePropertyAll(jungleGreen)),
              child: Text(
                  currentIndex < onboards.length - 1
                      ? 'Continue'
                      : 'Get started',
                  style: medium10)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/login'),
            child: Text(
              'Skip for now',
              style: GoogleFonts.quicksand(
                  fontSize: 14, color: Theme.of(context).colorScheme.outline),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

typedef _OnboardContent = ({String title, String content, String imageUrl});

const onboards = <_OnboardContent>[
  (
    title: 'Take Quizzes',
    content: 'Test your knowledge with quizzes by set creators on our platform '
        'over a wide range of topics and categories',
    imageUrl: 'asset/undraw/welcome_onboard.svg'
  ),
  (
    title: 'Follow Creators',
    content:
        'Follow creators on our platform to stay'
        ' up to date with their latest Quizzes on the platform',
    imageUrl: 'asset/undraw/follow_users.svg'
  ),
];

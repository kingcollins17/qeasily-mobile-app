// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qeasily/db/db.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                              const SizedBox(height: 30),
                              Text(onboards[index].title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(height: 20),
                              Text(
                                onboards[index].content,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
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
                                ? Theme.of(context).colorScheme.primary
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
                // Hive.box<AppConfig>('settings').get('config')
                //   ?..darkMode = true
                //   ..save();
                if (currentIndex >= onboards.length) {
                  context.push('/test');
                }
              },
              style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                Size(MediaQuery.of(context).size.width * 0.8, 45),
              )),
              child: Text(
                currentIndex < onboards.length - 1 ? 'Continue' : 'Get started',
                style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )),
          Text(
            'Skip for now',
            style: GoogleFonts.quicksand(
                fontSize: 14, color: Theme.of(context).colorScheme.outline),
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
    title: 'Quiz',
    content: 'Test your knowledge with quizzes by set creators on our platform '
        'over a wide range of topics and category',
    imageUrl: 'asset/ils/undraw_exams_re_4ios.svg'
  ),
  (
    title: 'Progress Tracking',
    content: 'Track all your quiz progress and see how you have '
        'performed for a specific timeline',
    imageUrl: 'asset/ils/undraw_personal_goals_re_iow7.svg'
  ),
  (
    title: 'Paid Challenge',
    content:
        'Participate in online paid challenges and compete with other users '
        'on our platform to earn real cash rewards ',
    imageUrl: 'asset/ils/undraw_completing_re_i7ap.svg'
  ),
  (
    title: 'Leaderboards',
    content:
        'See the leaderboards and ranking to see your progress and performance in a Quiz Challenge',
    imageUrl: 'asset/ils/undraw_grades_re_j7d6.svg'
  ),
];

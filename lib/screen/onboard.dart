// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SvgPicture.asset('asset/ils/undraw_education_f8ru.svg'),
      ]),
    );
  }
}

typedef _OnboardContent = ({String title, String content, String imageUrl});

const onboards = <_OnboardContent>[
  (
    title: 'Quiz',
    content: 'Take test quizzes on our platform on any category '
        'or topic to challenge your skills',
    imageUrl: 'asset/ils/undraw_exams_re_4ios.svg'
  ),
  (
    title: 'Progress Tracking',
    content: 'Track all your quiz progress and see how you have '
        'performed for a specific timeline',
    imageUrl: 'asset/ils/undraw_progress_tracking_re_ulfg.svg'
  ),
  (
    title: 'Paid Challenges',
    content: 'Participate in paid quiz challenges and compete with other users'
        'on our platform to earn real cash rewards ',
    imageUrl: 'asset/ils/undraw_quiz_re_aol4.svg'
  ),
  (
    title: 'Leaderboards',
    content:
        'See the leaderboards and ranking to see your progress and performance in a Quiz Challenge',
    imageUrl: 'asset/ils/undraw_grades_re_j7d6.svg'
  ),
];

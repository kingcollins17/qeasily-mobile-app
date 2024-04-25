import 'package:qeasily/model/model.dart';

///
abstract interface class QuizOnboardState {
  final QuizData quiz;

  QuizOnboardState({required this.quiz});

  List<String> get instructions;

  String get title;
  String get label;

  ///
  bool startQuiz();
}

class MCQOnboardState extends QuizOnboardState {
  MCQOnboardState({required super.quiz});

  @override
  List<String> get instructions => <String>[
        'All unanswered Questions will appear grey',
        'Answered Questions will appear in  Purple',
        'Double tap on option to unpick it',
        'Tap once on an option to select it',
        'If your time runs out, you will automatically submit',
      ];

  @override
  String get label => 'Multiple Choice';
  @override
  String get title => quiz.title;

  @override
  bool startQuiz() {
    throw UnimplementedError();
  }
}

class DCQOnboardState extends QuizOnboardState {
  DCQOnboardState({required super.quiz});

  @override
  List<String> get instructions => <String>[
        'Answer true or false for each question',
        'Unanswered questions will appear grey',
        'Answered questions would appear green',
        'Try to finish before the alloted time',
        'Goodluck and Godspeed',
      ];

  @override
  String get label => 'Dual Choice';

  @override
  String get title => quiz.title;

  @override
  bool startQuiz() {
    throw UnimplementedError();
  }
}

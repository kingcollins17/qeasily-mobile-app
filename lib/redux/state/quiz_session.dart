import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

part 'quiz_session.g.dart';

abstract class SessionState {
  final QuizData quiz;
  int _current;

  int get current => _current;

  set current(int value) {
    if (current < availableQuestions.length) _current = value;
  }

  PageData currentPage;
  Duration? timeLeft;

  ///Implemented by sub classes and returns the list of available question data
  List get availableQuestions;

  ///Always call before dispatching the thunk action [fetchNextQuestions]
  bool get shouldLoadMore {
    return (current >= availableQuestions.length - 2) &&
        currentPage.hasNextPage;
  }

  SessionState(
      {required this.quiz,
      required int current,
      required this.currentPage,
      this.timeLeft})
      : _current = current;

  Future<(List<T> data, PageData page, String detail)> fetchNextQuestions<T>(
      Dio dio,
      {required T Function(dynamic) converter}) async {
    try {
      if (currentPage.hasNextPage) {
        final resp = await dio.get(
          APIUrl.fetchQuizQuestions.url,
          data: (currentPage..next()).toJson(),
          queryParameters: {'quiz_id': quiz.id},
        );

        if (resp.statusCode == 200) {
          final {
            'detail': detail,
            'data': data,
            'has_next_page': hasNext,
            'page': page
          } = resp.data;

          return (
            (data as List).map((e) => converter(e)).toList(),
            PageData.fromJson(page)..hasNextPage = hasNext,
            detail.toString()
          );
        } //else if response code is not 200
        else {
          return (<T>[], currentPage, resp.data['detail'].toString());
        }
      }
      //else if there is no next page
      else {
        return (<T>[], currentPage, 'Current Page has no next Page');
      }
    } catch (e) {
      return (<T>[], currentPage, e.toString());
    }
  }

  void addQuestions(List data);

  ///
  void pickOption(option, int index);

  ///
  void unpickOption(int index);

  ///
  Object saveSession(Duration timeLeft);
}

class MCQSessionState extends SessionState {
  List<MCQData> questions;
  List<MCQOption?> choices;
  // Duration? timeLeft;

  MCQSessionState({
    required super.quiz,
    required super.current,
    required super.currentPage,
    super.timeLeft,
    this.questions = const <MCQData>[],
    this.choices = const <MCQOption?>[],
  });

  @override
  void pickOption(option, int index) {
    try {
      if (option is MCQOption) {
        choices[index] = option;
      }
    } on RangeError catch (_) {}
  }

  @override
  SavedMCQSession saveSession(Duration timeLeft) => SavedMCQSession(
      quiz: quiz,
      questions: questions,
      secondsLeft: timeLeft.inSeconds,
      current: current,
      choices: choices,
      currentPage: currentPage);

  @override
  void unpickOption(int index) {
    try {
      choices[index] = null;
    } on RangeError catch (_) {}
  }

  @override
  toString() =>
      'MCQSession{quiz: ${quiz.title}, questions: $questions, current: $current '
    
      'currentPage: $currentPage'
      'questions, choices: $choices}';

  @override
  List get availableQuestions => questions;

  @override
  void addQuestions(List data) {
    if (data case [MCQData _, ...]) {
      questions = {...questions, ...data.cast<MCQData>()}.toList();
    }
  }
}

class DCQSessionState extends SessionState {
  List<DCQData> questions;
  List<bool?> choices;
  DCQSessionState(
      {required super.quiz,
      required super.current,
      required super.currentPage,
      super.timeLeft,
      this.questions = const <DCQData>[],
      this.choices = const <bool?>[]});

  @override
  void pickOption(option, int index) {
    try {
      if (option is bool) {
        choices[index] = option;
      }
    } on RangeError catch (_) {}
  }

  @override
  SavedDCQSession saveSession(Duration timeLeft) => SavedDCQSession(
      questions: questions,
      quiz: quiz,
      choices: choices,
      secondsLeft: timeLeft.inSeconds,
      current: current,
      currentPage: currentPage);

  @override
  void unpickOption(int index) {
    try {
      choices[index] = null;
    } on RangeError catch (_) {}
  }

  @override
  toString() =>
      'DCQSession{quiz: ${quiz.title}, choices: $choices, current: $current,'
      ' currentPage: $currentPage'
      ' questions: $questions, timeLeft: $timeLeft}';

  @override
  List get availableQuestions => questions;

  @override
  void addQuestions(List data) {
    if (data case [DCQData _, ...]) {
      questions = {...questions, ...data.cast<DCQData>()}.toList();
    }
  }
}

///
@JsonSerializable()
class QuizSession {
  @JsonKey(includeFromJson: false, includeToJson: false)
  SessionState? session;

  String? message;
  bool isLoading = false;

  ///Whether application is currently in a session
  bool get inSession => session != null;

  factory QuizSession.fromJson(Map<String, dynamic> json) =>
      _$QuizSessionFromJson(json);

  QuizSession({this.message});

  Map<String, dynamic> toJson() => _$QuizSessionToJson(this);

  @override
  toString() =>
      'QuizSession{message: $message, isLoading: $isLoading, session: $session}';
}

@JsonSerializable()
class SessionHistory {
  List<SavedMCQSession> mcqSessions;
  List<SavedDCQSession> dcqSessions;
  SessionHistory({
    this.mcqSessions = const <SavedMCQSession>[],
    this.dcqSessions = const <SavedDCQSession>[],
  });

  factory SessionHistory.fromJson(Map<String, dynamic> json) =>
      _$SessionHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SessionHistoryToJson(this);

  @override
  toString() => 'SessionHistory{mcqs: $mcqSessions, dcqs: $dcqSessions}';
}

abstract interface class SavedSession {
  SessionState restoreSession();
}

@JsonSerializable()
class SavedMCQSession implements SavedSession {
  final QuizData quiz;
  final List<MCQData> questions;
  final int secondsLeft;
  final int current;
  final List<MCQOption?> choices;
  final PageData currentPage;

  factory SavedMCQSession.fromJson(Map<String, dynamic> json) =>
      _$SavedMCQSessionFromJson(json);

  SavedMCQSession(
      {required this.quiz,
      required this.questions,
      required this.secondsLeft,
      required this.current,
      required this.choices,
      required this.currentPage});
  Map<String, dynamic> toJson() => _$SavedMCQSessionToJson(this);

  @override
  SessionState restoreSession() => MCQSessionState(
      quiz: quiz,
      current: current,
      currentPage: currentPage,
      timeLeft: Duration(seconds: secondsLeft),
      questions: questions,
      choices: choices);

  @override
  bool operator ==(covariant SavedMCQSession other) {
    return identical(this, other) || (quiz == other.quiz);
  }

  @override
  int get hashCode => quiz.title.hashCode ^ quiz.id.hashCode;

  @override
  toString() => 'SavedMCQSession{quiz: ${quiz.title}, current: $current,'
      ' timeLeft: $secondsLeft minutes, page: $currentPage, choices: $choices}';
}

@JsonSerializable()
class SavedDCQSession implements SavedSession {
  final List<DCQData> questions;
  final QuizData quiz;
  final List<bool?> choices;
  final int secondsLeft;
  final int current;
  final PageData currentPage;

  factory SavedDCQSession.fromJson(Map<String, dynamic> json) =>
      _$SavedDCQSessionFromJson(json);

  SavedDCQSession(
      {required this.questions,
      required this.quiz,
      required this.choices,
      required this.secondsLeft,
      required this.current,
      required this.currentPage});
  Map<String, dynamic> toJson() => _$SavedDCQSessionToJson(this);

  @override
  SessionState restoreSession() => DCQSessionState(
      quiz: quiz,
      current: current,
      currentPage: currentPage,
      timeLeft: Duration(seconds: secondsLeft),
      questions: questions,
      choices: choices);

  @override
  bool operator ==(covariant SavedDCQSession other) {
    return identical(this, other) || (quiz == other.quiz);
  }

  @override
  int get hashCode => quiz.title.hashCode ^ quiz.id.hashCode;

  @override
  toString() => 'SavedDCQSession{quiz: ${quiz.title}, current: $current,'
      'timeLeft: $secondsLeft minutes page: $currentPage, choices: $choices}';
}

class SessionAction {
  final SessionActionType type;
  final Object? payload;

  SessionAction({required this.type, this.payload});
}

enum SessionActionType {
  createSession,
  pickOption,
  unpickOption,
  next,
  previous,
  setCurrent,
  updateQuestions,
  load,
  endload,
  save,
  restore,
  notify,
  clearNotify,
  closeSession
}

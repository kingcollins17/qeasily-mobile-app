// ignore_for_file: no_leading_underscores_for_local_identifiers


import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_state.g.dart';

@JsonSerializable()
class QuizDataState {

  PageData page;

  List<QuizData> quizzes;


  String? message;

  bool isLoading = false;
  
  int? topic, category;

  QuizDataState({PageData? page, List<QuizData>? quizzes})
      : page = page ?? PageData(),
        quizzes = quizzes ?? const <QuizData>[];


  factory QuizDataState.fromJson(Map<String, dynamic> json) =>
      _$QuizDataStateFromJson(json);

  Map<String, dynamic> toJson() => _$QuizDataStateToJson(this);

  @override
  toString() => 'QuizState{page: $page, message: $message, quizzes:'
      ' $quizzes, isLoading:'
      ' $isLoading, topic: $topic, category: $category}';
}

class QuizAction {
  final QuizActionType type;
  final Object? payload;

  const QuizAction({required this.type, this.payload});
}

enum QuizActionType {
  load,
  endload,
  update,
  notify,
  clearNotify,
  reset,
  resetPage,
  selectTopic,
  selectCategory,
  unselectTopic,
  unselectCategory
}




typedef QuizResp = ({
  List<QuizData> data,
  String detail,
  bool? hasNextPage,
  PageData? page,
  bool status
});

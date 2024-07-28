// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/categories.dart';
// import 'package:qeasily/provider/created_quizzes.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/widget.dart';

class CreateQuizScreen extends ConsumerStatefulWidget {
  const CreateQuizScreen({super.key});
  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen>
    with Ui, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  bool isLoading = false;
  bool showHelp = false;
  LocalNotification? notification;

  //form arguments
  String? title, description, difficulty;
  QuestionType? questionType;
  int? duration;
  CategoryData? category;
  TopicData? topic;
  List<int>? questions;

  //test data
  dynamic testData;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller);
  }

  Future<dynamic> _pickQuestions() async {
    if ((_formKey.currentState?.validate() ?? false) &&
        (topic?.id != null &&
            duration != null &&
            difficulty != null &&
            questionType != null)) {
      final picked = await push(
          QuestionSelectorScreen(
            topic: (topic!, questionType!),
          ),
          context);
      switch (picked) {
        case List<MCQData> _:
          break;
        case List<DCQData> _:
          break;
        default:
      }
    } else {
      await _notify(
        'You must fill out the fields on this page before you proceed to pick questions',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title: Text('Create Quiz', style: small00),
          // : Column(children: [],),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            // crossAxisAlignment: C,
            children: [
              StoreConnector<QeasilyState, TopicVM>(
                  converter: (store) => TopicVM(store),
                  builder: (context, vm) {
                    return Form(
                        key: _formKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spacer(y: 20),
                            Text('Title', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            inputField(
                                hint: 'What is the name of this quiz?',
                                validator: validator,
                                onChanged: (value) => title = value),
                            spacer(y: 15),
                            Text('Description', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            inputField(
                                hint: 'Briefly describe this quiz',
                                validator: validator,
                                onChanged: (value) => description = value,
                                maxLines: 5),
                            spacer(y: 15),
                            Text('Category', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            switch (ref.read(categoriesProvider)) {
                              AsyncData(value: List<CategoryData> data) =>
                                CustomDropdownField(
                                  items: data,
                                  onChanged: (p0) {
                                    setState(() => category = p0);
                                  },
                                  converter: (p0) => p0.name,
                                ),
                              _ => Center(child: Text(''))
                            },
                            spacer(y: 15),
                            Text('Topic', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            GestureDetector(
                              onTap: () {
                                if (category == null) {
                                  _notify('You must select category first');
                                } else {
                                  push(
                                          TopicSelectorScreen(
                                              category: category!,
                                              multiple: false),
                                          context)
                                      .then((value) {
                                    if (value case [TopicData arg]) {
                                      setState(() => topic = arg);
                                    } else {
                                      _notify('Invalid topic selection');
                                    }
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                width: maxWidth(context) * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: raisingBlack,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    topic?.title ?? 'Tap to select topic',
                                    style: mukta),
                              ),
                            ),
                            spacer(y: 20),
                            Text('Questions', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 15),
                            GestureDetector(
                              onTap: () => topic == null || questionType == null
                                  ? _notify('You must select topic and/or the'
                                      ' question type before your proceed')
                                  : push(
                                          QuestionSelectorScreen(
                                            topic: (topic!, questionType!),
                                          ),
                                          context)
                                      .then((value) {
                                      if (value is List) {
                                        setState(() {
                                          questions = value
                                              .map((e) => e.id as int)
                                              .toList();
                                        });
                                      }
                                    }),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                width: maxWidth(context) * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: raisingBlack,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    questions != null
                                        ? '${questions!.length} Questions selected'
                                        : 'Tap to select Questions',
                                    style: mukta),
                              ),
                            ),
                            spacer(y: 15),
                            Text('Select Duration', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            CustomDropdownField(
                                items: [5, 10, 20, 30, 45, 60],
                                onChanged: (value) => duration = value,
                                converter: (value) => '$value minutes'),
                            spacer(y: 15),
                            Text('Type', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            () {
                              const _map = {
                                'Multiple Choice': QuestionType.mcq,
                                'True or False': QuestionType.dcq
                              };
                              return CustomDropdownField(
                                  items: _map.keys.toList(),
                                  onChanged: (value) =>
                                      questionType = _map[value],
                                  converter: (value) => value);
                            }(),
                            // Text(quizType.toString()),

                            spacer(y: 15),
                            Text('Select Difficulty', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            CustomDropdownField(
                                items: ['Easy', 'Medium', 'Hard'],
                                onChanged: (value) => difficulty = value,
                                converter: (value) => value),
                            spacer(y: 15),

                            // Text(questions?.toString() ??
                            // 'No questions selected yet')
                          ],
                        ));
                  }),
              // Text(testData.toString()),

              spacer(y: 80),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        width: maxWidth(context),
        child: Center(
          child: FilledButton(
              style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(
                    maxWidth(context) * 0.85,
                    40,
                  )),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(jungleGreen)),
              onPressed: () async {
                if (questions == null) {
                  _notify(
                      'You must select questions for this quiz before you proceed');
                } else {
                  // try {
                  await _notify('Creating your Quiz', loading: true, delay: 2);

                  final (status, msg) = await _createQuiz(
                    ref.read(generalDioProvider),
                    title: title!,
                    description: description!,
                    questions: questions!,
                    topicId: topic!.id,
                    durationInMinutes: duration!,
                    difficulty: difficulty!,
                    type: questionType!,
                  );
                  await _notify(msg, loading: false, delay: 3);

                  if (status) context.go('/home');
                  // }
                }
              },
              // icon: Icon(Icons.publish_rounded, color: athensGray, size: 25),
              child: isLoading
                  ? SpinKitThreeBounce(color: athensGray, size: 20)
                  : Text('Publish Quiz', style: small00)),
        ),
      ),
      if (showHelp)
        Center(
          child: TutorialHint(
            title: 'Hint',
            message: createQuizTutorial,
            closer: () {
              setState(() => showHelp = false);
            },
          ),
        ),
      Positioned(
          bottom: 80,
          right: 20,
          child: ShowHelpWidget(
            onPressHelp: () => setState(() {
              showHelp = !showHelp;
            }),
          ))
    ], notification);
  }
}

String? validator(String? value) =>
    value == null || value.isEmpty ? 'This field is required' : null;

extension _Align on Widget {
  Align align(Alignment alignment) => Align(
        alignment: alignment,
        child: this,
      );
}

Future<(bool, String)> _createQuiz(Dio dio,
    {required String title,
    required String description,
    required List<int> questions,
    required int topicId,
    required int durationInMinutes,
    required String difficulty,
    required QuestionType type}) async {
  try {
    final res = await dio.post(APIUrl.createQuiz.url, data: {
      'title': title,
      'questions': questions,
      'description': description,
      'duration': durationInMinutes * 60,
      'type': type.name,
      'difficulty': difficulty,
      'topic_id': topicId
    });
    final {'detail': msg} = res.data;
    if (res.statusCode == 200) {
      return (true, msg.toString());
    }
    //
    return (false, msg.toString());
  } catch (e) {
    return (false, e.toString());
  }
}

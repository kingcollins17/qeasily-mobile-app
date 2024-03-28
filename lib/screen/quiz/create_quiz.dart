// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/notification.dart';
import 'package:qeasily/widget/widget.dart';

import 'widget/widget.dart';

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
  LocalNotification? notification;

  //form arguments
  String? title, description, difficulty;
  QuestionType? quizType;
  int? duration, topicId;
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

  Future<dynamic> _goToPickQuestions() async {
    if ((_formKey.currentState?.validate() ?? false) &&
        (topicId != null &&
            duration != null &&
            difficulty != null &&
            quizType != null)) {
      questions = await push<List<int>>(
          PickQuestionsView(
            type: quizType!,
            topicId: topicId!,
          ),
          context);
      await _notify('Questions selection complete!', loading: false);
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
                            spacer(y: 20),
                            Text('Topic', style: small00)
                                .align(Alignment.centerLeft),
                            spacer(y: 10),
                            CustomDropdownField(
                                items: vm.state.topics,
                                onChanged: (topic) => topicId = topic.id,
                                converter: (topic) => topic.title),
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
                                  onChanged: (value) => quizType = _map[value],
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
              spacer(y: 50),
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
                    maxWidth(context) * 0.9,
                    42,
                  )),
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () async {
                if (questions == null) {
                  _goToPickQuestions();
                } else {
                  // try {
                  await _notify('Creating your Quiz', loading: true, delay: 2);

                  final (status, msg) = await _createQuiz(
                    ref.read(generalDioProvider),
                    title: title!,
                    description: description!,
                    questions: questions!,
                    topicId: topicId!,
                    durationInMinutes: duration!,
                    difficulty: difficulty!,
                    type: quizType!,
                  );

                  await _notify(msg, loading: false, delay: 3);
                  // ignore: use_build_context_synchronously
                  if (status) Navigator.pop(context);
                }
              },
              child: isLoading
                  ? SpinKitThreeBounce(color: Colors.black, size: 20)
                  : Text(questions == null ? 'Pick Questions' : 'Create Quiz',
                      style: rubik)),
        ),
      )
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

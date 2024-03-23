// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_field

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/notification.dart';

//
import 'create_question_util.dart';

class CreateQuestions extends ConsumerStatefulWidget {
  const CreateQuestions({super.key});
  @override
  ConsumerState<CreateQuestions> createState() => _CreateQuestionsState();
}

class _CreateQuestionsState extends ConsumerState<CreateQuestions>
    with SingleTickerProviderStateMixin, Ui {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // String _type = 'mcq'
  QType? qType;
  late AnimationController _controller;

  LocalNotification? notification;

  int total = 0, current = 0;

  void initaliseParams() {
    if (total < current || qType == null)
      // ignore: curly_braces_in_flow_control_structures
      throw Exception('Intializing not complete!');
    else {
      draft = List.generate(total, (index) => MCQDraft());

      assert(total == draft!.length && total > current);
    }
  }

  List<Draft>? draft;
  var step = _Step.selectCount;

  dynamic response;

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

  Future<void> _notify(String message, {bool? loading, int delay = 5}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });

    return showNotification(_controller, delay);
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title: Text('Create Question', style: mukta),
        ),
        body: SingleChildScrollView(
          child: switch (step) {
            _Step.selectCount => _selectCount(),
            _Step.selectType => _selectType(),
            _Step.create when qType == QType.mcq => _addMCQ(),
            _Step.create when qType == QType.dcq => _addDCQ(),
            _ => SizedBox()
          },
        ),
      ),
    ], notification);
  }

  Widget _addMCQ() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              spacer(y: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Questions ${current + 1} of $total',
                      style: small00)),
              // spacer(y: 10),
              spacer(y: 20),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputField(
                    label: 'Query',
                    onChanged: (value) => setState(() {
                      final obj = draft![current] as MCQDraft;
                      obj.query = value;
                    }),
                  ),
                  spacer(y: 12),
                  inputField(
                    label: 'Option A',
                    onChanged: (value) => setState(() {
                      (draft![current] as MCQDraft).A = value;
                    }),
                  ),
                  // spacer(),
                  spacer(y: 12),
                  inputField(
                    label: 'Option B',
                    onChanged: (value) => setState(() {
                      (draft![current] as MCQDraft).B = value;
                    }),
                  ),
                  // spacer(),
                  spacer(y: 12),
                  inputField(
                    label: 'Option C',
                    onChanged: (value) => setState(() {
                      (draft![current] as MCQDraft).C = value;
                    }),
                  ),
                  // spacer(),
                  spacer(y: 12),
                  inputField(
                    label: 'Option D',
                    onChanged: (value) => setState(() {
                      (draft![current] as MCQDraft).D = value;
                    }),
                  ),
                  spacer(y: 15),
                  Text(
                    'Explanation',
                    style: small00,
                  ),
                  spacer(y: 10),
                  inputField(
                    maxLines: 10,
                    minLines: 4,
                    hint: 'Give a thorough explanation of the'
                        ' answer to this question',
                    onChanged: (value) => setState(() {
                      (draft![current] as MCQDraft).explanation = value;
                    }),
                  ),
                ],
              )),
              spacer(y: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => current + 1 < total
                          ? setState(() {
                              current += 1;
                            })
                          : null,
                      child: direction(dir: 'left')),
                  GestureDetector(
                      onTap: () => current > 0
                          ? setState(() {
                              current -= 1;
                            })
                          : null,
                      child: direction(dir: 'right'))
                ],
              ),
              spacer(y: 100),
              Text(draft.toString()),
            ],
          ),
        ),
      );

  TextFormField inputField(
      {int maxLines = 1,
      int minLines = 1,
      String? label,
      String hint = '',
      void Function(String? value)? onChanged}) {
    return TextFormField(
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      style: mukta,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        fillColor: raisingBlack,
        // isDense: true,
        border: OutlineInputBorder(),
        // hintText: 'Enter your Question',
        hintText: hint,
        hintStyle: mukta,
        // labelText: 'Query',
        labelText: label,
        labelStyle: mukta,
      ),
    );
  }

  Widget _addDCQ() => Column(
        children: [],
      );

  Widget _selectType() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            spacer(y: 15),
            Text('Select the type of Question', style: mukta),
            spacer(y: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 48,
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonFormField<int>(
                hint: Text('Multiple Choice', style: xs01),
                padding: EdgeInsets.symmetric(horizontal: 10),
                // value: 0,
                decoration: InputDecoration(border: InputBorder.none),
                isDense: true,
                items: List.generate(
                  QType.values.length,
                  (index) => DropdownMenuItem(
                      value: index,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          QType.values[index].name == 'mcq'
                              ? 'Multiple Choice'
                              : 'True or False',
                          style: mukta,
                        ),
                      )),
                ),
                onChanged: (value) {
                  setState(() => qType = QType.values[value ?? 0]);
                },
              ),
            ),
            spacer(y: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                direction(dir: 'left'),
                GestureDetector(
                  onTap: () async {
                    initaliseParams();
                    step = _Step.create;
                    await _notify('You can start creating your questions');
                    await _notify('You can choose to save to draft or '
                        'publish after creating your questions');
                  },
                  child: direction(dir: 'right'),
                ),
              ],
            ),
            // Text(qType.toString())
          ],
        ),
      );
  Widget _selectCount() => Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(y: 20),
              Text(
                'How many questions do you wish to add?',
                style: mukta,
              ),
              spacer(y: 20),
              TextField(
                onChanged: (value) =>
                    setState(() => total = int.tryParse(value) ?? 0),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '10',
                  labelText: 'Select No of Questions',
                  border: OutlineInputBorder(),
                ),
              ),
              spacer(y: 20),
              Text(total.toString()),
              GestureDetector(
                  onTap: () => setState(() {
                        step = _Step.selectType;
                      }),
                  child: direction(dir: 'right')),
              // Text(total.toString()),
              // Text(draft?.toString() ?? 'No drafts')
            ],
          ),
        ),
      );
}

enum _Step { selectCount, selectType, create }

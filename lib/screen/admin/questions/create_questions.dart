// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/app_constants.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/view_model/topic_vm.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/confirm_action.dart';
import 'package:qeasily/widget/widget.dart';

///The two constructor must either be provided together or not at all
class CreateQuestionsScreen extends ConsumerStatefulWidget {
  const CreateQuestionsScreen({super.key, this.initialDraft, this.initialType})
      : assert((initialDraft == null && initialType == null) ||
            (initialDraft != null) && initialType != null);
  final List<Draft>? initialDraft;
  final QuestionType? initialType;
  @override
  ConsumerState<CreateQuestionsScreen> createState() => _CreateQuestionsState();
}

class _CreateQuestionsState extends ConsumerState<CreateQuestionsScreen>
    with SingleTickerProviderStateMixin, Ui {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // String _type = 'mcq'

  late AnimationController _controller;

  LocalNotification? notification;

  QuestionType? questionType;
  TopicData? topic;
  CategoryData? category;
  int total = 0, current = 0;

  void initaliseParams() {
    if (total < current || questionType == null && topic != null)
      // ignore: curly_braces_in_flow_control_structures
      throw Exception('Intialization could not complete!');
    else {
      draft = switch (questionType) {
        QuestionType.mcq =>
          List.generate(total, (index) => MCQDraft(topicId: topic!.id)),
        //
        QuestionType.dcq =>
          List.generate(total, (index) => DCQDraft(topicId: topic!.id)),
        _ => null
      };

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
    //
    if (widget.initialDraft != null && widget.initialType != null) {
      //Go to straight to creating
      total = widget.initialDraft!.length;
      current = 0;
      draft = widget.initialDraft!;
      questionType = widget.initialType!;
      step = _Step.create;
    }
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
          title: step == _Step.create
              ? Text('Set Questions ${current + 1}', style: small00)
              : null,
        ),
        body: SingleChildScrollView(
          child: switch (step) {
            _Step.selectCount => _selectTotalCount(),
            _Step.selectType => _selectTypeAndTopic(),
            _Step.create when questionType == QuestionType.mcq => _addMCQ(),
            _Step.create when questionType == QuestionType.dcq => _addDCQ(),
            _ => SizedBox()
          },
        ),
      ),
    ], notification);
  }

  Widget _addMCQ() {
    final _current = (draft![current] as MCQDraft);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            spacer(y: 10),
            Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('Questions ${current + 1} of $total', style: small00)),
            // spacer(y: 10),
            spacer(y: 20),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputField(
                  label: 'Query',
                  hint: _current.query,
                  onChanged: (value) => _current.query = value,
                ),
                spacer(y: 12),
                _inputField(
                  label: 'Option A',
                  hint: _current.A,
                  onChanged: (value) => _current.A = value,
                ),
                // spacer(),
                spacer(y: 12),
                _inputField(
                    label: 'Option B',
                    hint: _current.B,
                    onChanged: (value) => _current.B = value),
                // spacer(),
                spacer(y: 12),
                _inputField(
                    label: 'Option C',
                    hint: _current.C,
                    onChanged: (value) => _current.C = value),
                // spacer(),
                spacer(y: 12),
                _inputField(
                    label: 'Option D',
                    hint: _current.D,
                    onChanged: (value) =>
                        (draft![current] as MCQDraft).D = value),
                spacer(y: 15),
                Text('Correct Option', style: small00),
                spacer(y: 10),
                CustomDropdownField(
                    items: MCQOption.values,
                    hint: 'Tap to select any option',
                    onChanged: (value) {
                      _current.correct = value;
                    },
                    converter: (value) => value.name),
                spacer(y: 10),
                Text(
                  'Explanation',
                  style: small00,
                ),
                spacer(y: 10),
                _inputField(
                  maxLines: 10,
                  minLines: 4,
                  hint: _current.explanation ??
                      'Give a thorough explanation of the'
                          ' answer to this question',
                  // hint: 'Give a thorough explanation of the'
                  //     ' answer to this question',
                  onChanged: (value) => _current.explanation = value ?? '',
                ),
                spacer(y: 15),
                Text('Select difficulty', style: small00),
                spacer(y: 10),
                CustomDropdownField(
                    items: MCQDifficulty.values,
                    onChanged: (value) {
                      _current.difficulty = value;
                    },
                    converter: (value) => value.name.toUpperCase()),
                spacer(y: 10),
              ],
            )),
            spacer(y: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('$current and $total'),
                GestureDetector(
                    onTap: () => current > 0
                        ? setState(() {
                            current -= 1;
                          })
                        : null,
                    child: direction(dir: 'left')),
                GestureDetector(
                    onTap: () => current + 1 < total
                        ? setState(() {
                            current += 1;
                          })
                        : null,
                    child: direction(dir: 'right'))
              ],
            ),
            spacer(y: 10),
            if (current == total - 1)
              FilledButton(
                  onPressed: () async {
                    if (draft != null && draft!.isNotEmpty) {
                      final publish = await showModal(
                        context: context,
                        builder: (context) => ConfirmAction(
                            action:
                                'Are you sure you want to publish these questions',
                            onConfirm: () => Navigator.pop(context, true)),
                      );
                      //return if publish is not true
                      if (publish != true) return;
                      _notify('Publishing questions', loading: true);
                      final dio = ref.read(generalDioProvider);

                      final (status, msg, data) = switch (draft!.first) {
                        MCQDraft _ => await publishMCQuestions(
                            dio,
                            draft!.cast<MCQDraft>(),
                          ),
                        DCQDraft _ => await publishDCQuestions(
                            dio,
                            draft!.cast<DCQDraft>(),
                          ),
                        _ => (false, 'No match', null)
                      };
                      await _notify(msg, loading: false);
                      if (status) {
                        _notify(
                            'You can go to View Questions to see your newly added Questions',
                            loading: false);
                      } else if (data != null) {
                        _notify(
                            'Questions'
                            ' ${(data as List).map((e) => (e + 1).toString()).toList()} '
                            'are invalid, please review them',
                            loading: false);
                      }
                    } else {
                      _notify('Your edit is still empty');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      fixedSize:
                          MaterialStatePropertyAll(Size(maxWidth(context), 42)),
                      foregroundColor: MaterialStatePropertyAll(woodSmoke)),
                  child: isLoading
                      ? SpinKitThreeBounce(color: Colors.black, size: 20)
                      : Text('Publish Questions', style: rubik)),

            // Text(draft.toString()),
            FilledButton(
                onPressed: () async {
                  try {
                    final name = await _showSaveDraft();
                    if (name != null) {
                      await _notify('Saving your Questions to $name');
                      saveMCQToStorage(
                          draft: draft!.cast<MCQDraft>(),
                          box: Hive.box<List<Map>>(mcqDrafts),
                          draftName: name);
                      await _notify('Questions have been saved to draft',
                          loading: false);
                      _notify(
                          'You can go to the Drafts page to see your saved questions');
                    }
                  } on Exception catch (e) {
                    _notify(e.toString(), loading: false);
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(tiber),
                    foregroundColor: MaterialStatePropertyAll(athensGray)),
                child: Text('Save Edit to Draft', style: rubik)),
            // if ()
            // Text(draft![current].toString()),
            spacer(y: 50),
          ],
        ),
      ),
    );
  }

  TextFormField _inputField(
      {int maxLines = 1,
      int minLines = 1,
      String? label,
      String? hint,
      void Function(String? value)? onChanged}) {
    return TextFormField(
      key: ValueKey('$label $current '),
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
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

  Widget _addDCQ() {
    final _current = draft![current] as DCQDraft;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          spacer(y: 10),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Questions ${current + 1} of ${draft!.length}',
                  style: mukta)),
          spacer(y: 20),
          _inputField(
            label: 'Query',
            hint: _current.query,
            onChanged: (value) => setState(() {
              _current.query = value;
            }),
          ),
          spacer(y: 15),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Correct Option', style: small00)),
          spacer(y: 10),
          CustomDropdownField(
              items: [true, false],
              hint: _current.correct.toString().toUpperCase(),
              onChanged: (value) {
                _current.correct = value;
              },
              converter: (value) => value.toString().toUpperCase()),
          spacer(y: 15),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Explanation', style: small00)),
          spacer(y: 10),
          _inputField(
              // hint: 'Explain your answer',
              hint: _current.explanation ?? 'Explain your answer',
              onChanged: (value) => setState(() {
                    _current.explanation = value;
                  }),
              maxLines: 6),
          spacer(y: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () =>
                      current > 0 ? setState(() => current -= 1) : null,
                  child: direction(dir: 'left')),
              GestureDetector(
                  onTap: () => current + 1 < draft!.length
                      ? setState(() => current += 1)
                      : null,
                  child: direction(dir: 'right'))
            ],
          ),
          spacer(y: 20),
          if (current == draft!.length - 1)
            FilledButton(
                onPressed: () async {
                  final publish = await showModal(
                      context: context,
                      builder: (context) => ConfirmAction(
                            action:
                                'Are you sure you want to publish these questions',
                            onConfirm: () => Navigator.pop(context, true),
                          ));
                  if (publish != true) {
                    _notify('Operation cancelled');
                    return;
                  }
                  _notify('Publishing Questions', loading: true);
                  final (status, msg, data) = await publishDCQuestions(
                      ref.read(generalDioProvider), draft!.cast<DCQDraft>());
                  await _notify(msg, loading: false);
                  if (!status && data != null) {
                    _notify('Questions $data are invalid, please review them');
                  }
                },
                style: ButtonStyle(
                    fixedSize:
                        MaterialStatePropertyAll(Size(maxWidth(context), 42)),
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                child: isLoading
                    ? SpinKitThreeBounce(color: Colors.black, size: 20)
                    : Text('Publish Questions', style: rubik)),
          FilledButton(
              onPressed: () async {
                try {
                  final name = await _showSaveDraft();
                  if (name != null) {
                    await _notify('Saving Questions to $name');
                    await saveDCQToStorage(
                        draft: draft!.cast(),
                        box: Hive.box<List>(dcqDrafts),
                        draftName: name);
                    await _notify('Questions saved to draft successfully',
                        delay: 3, loading: false);
                    _notify(
                        'You can go to the drafts page to view your questions',
                        loading: false);
                  }
                } on Exception catch (e) {
                  _notify(e.toString(), loading: false);
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(tiber),
                  foregroundColor: MaterialStatePropertyAll(athensGray)),
              child: Text('Save Edit to Draft', style: rubik)),
          // Text(draft.toString()),
        ],
      ),
    );
  }

  Future<String?> _showSaveDraft() {
    return showModal<String>(
      context: context,
      builder: (context) {
        String? draftName;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                    child: Ink(
                  // width: maxWidth(context) * 0.9,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  // height: 200,
                  decoration: BoxDecoration(
                    color: darkShade,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacer(y: 10),
                      Text('Name your draft', style: small00),
                      spacer(y: 10),
                      _inputField(
                          hint: 'Draft name',
                          onChanged: (value) => draftName = value),
                      spacer(y: 20),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, draftName),
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(
                                athensGray,
                              ),
                              backgroundColor: MaterialStatePropertyAll(tiber)),
                          child: Text('Save', style: rubik))
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _selectTypeAndTopic() {
    // const types = QuestionType.values;
    const typeMap = {
      QuestionType.mcq: 'Multiple Choice',
      QuestionType.dcq: ' True or False'
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacer(y: 15),
          Text('Select the type of Question', style: mukta),
          spacer(y: 15),
          CustomDropdownField(
            items: QuestionType.values,
            onChanged: (value) => setState(() {
              questionType = value;
            }),
            converter: (value) => typeMap[value].toString(),
          ),
          spacer(y: 15),
          switch (ref.read(categoriesProvider)) {
            AsyncData(:final value) => Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Select Category', style: mukta)),
                  spacer(y: 10),
                  CustomDropdownField(
                      items: value,
                      onChanged: (p0) {
                        category = p0;
                      },
                      converter: (p0) => p0.name),
                ],
              ),
            _ => SizedBox()
          },
          spacer(y: 25),
          Text('Select Topic of the Questions', style: mukta),
          spacer(y: 10),
          GestureDetector(
            onTap: () {
              if (category == null) {
                _notify('You must select category first!');
              } else {
                push(TopicSelectorScreen(category: category!, multiple: false),
                        context)
                    .then((value) {
                  if (value case [TopicData arg]) {
                    setState(() => topic = arg);
                  } else {
                    _notify('Selection is invalid');
                  }
                });
              }
            },
            child: Container(
              width: maxWidth(context) * 0.9,
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6), color: raisingBlack),
              child: Text(topic?.title ?? 'Tap to select Topic', style: mukta),
            ),
          ),
          // Text(topic.toString()),
          spacer(y: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              direction(dir: 'left'),
              GestureDetector(
                onTap: () async {
                  if (topic != null && questionType != null) {
                    initaliseParams();
                    step = _Step.create;
                    await _notify('You can start creating your questions');
                    await _notify('You can choose to save to draft or '
                        'publish after creating your questions');
                  } else {
                    await _notify(
                      'You must select Topic and Question type to proceed',
                    );
                  }
                },
                child: direction(dir: 'right'),
              ),
            ],
          ),
          // Text(qType.toString())
        ],
      ),
    );
  }

  Widget _selectTotalCount() => Container(
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
              // Text(total.toString()),
              Align(
                alignment: Alignment.centerLeft,
                // alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () => setState(() {
                          step = _Step.selectType;
                        }),
                    child: direction(dir: 'right')),
              ),
              // Text(total.toString()),
              // Text(draft?.toString() ?? 'No drafts')
            ],
          ),
        ),
      );
}

enum _Step { selectCount, selectType, create }

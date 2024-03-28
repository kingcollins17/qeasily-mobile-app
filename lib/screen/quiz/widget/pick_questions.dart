// ignore_for_file: unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/util.dart';
import 'package:qeasily/widget/widget.dart';

class PickQuestionsView extends ConsumerStatefulWidget {
  const PickQuestionsView(
      {super.key, required this.type, required this.topicId});
  final int topicId;
  final QuestionType type;
  @override
  ConsumerState<PickQuestionsView> createState() => _PickQuestionsViewState();
}

class _PickQuestionsViewState extends ConsumerState<PickQuestionsView>
    with Ui, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _scrollController = ScrollController();
  LocalNotification? notification;
  bool isLoading = false;

  var page = PageData();
  List<dynamic> data = [];

  var questions = <int>[];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) _fetchNext();
    });
    initializeData();
    //
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchNext() async {
    if (page.hasNextPage) {
      final _dio = ref.read(generalDioProvider);
      _notify('Please wait ...', loading: true);
      final (status, msg, _data, _page) = switch (widget.type) {
        QuestionType.mcq => await _fetchMCQ(_dio, page..next(), widget.topicId),
        QuestionType.dcq => await _fetchDCQ(_dio, page..next(), widget.topicId)
      };
      data.addAll(_data);
      page = _page;
      _notify(msg, loading: false);
    } else {
      _notify('No more data');
    }
  }

  Future<void> initializeData() async {
    _notify('Please wait ... ', loading: true);
    final (status, msg, _data, _page) = switch (widget.type) {
      QuestionType.mcq => await _fetchMCQ(
          ref.read(generalDioProvider), page..next(), widget.topicId),
      QuestionType.dcq => await _fetchDCQ(
          ref.read(generalDioProvider), page..next(), widget.topicId)
    };
    data = _data;
    page = _page;
    _notify(msg, loading: false);
  }

  Future<void> _notify(String message, {bool? loading, int delay = 4}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(
          title: Text('Select Questions', style: small00),
        ),
        body: ListView(
          controller: _scrollController,
          children: [
            ...List.generate(
              data.length,
              (index) => switch (widget.type) {
                QuestionType.mcq => mcqItem(data[index] as MCQData, index),
                QuestionType.dcq => dcqItem(data[index] as DCQData, index)
              },
            ),
            spacer(),
            if (isLoading && data.isNotEmpty)
              SpinKitThreeBounce(color: Colors.white, size: 25),
            spacer(y: 25),
          ],
        ),
      ),
      Positioned(
          width: maxWidth(context),
          bottom: 15,
          child: Center(
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context, questions.isNotEmpty ? questions : null);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.black),
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: Text(
                'I am done',
                style: rubik,
              ),
            ),
          ))
    ], notification);
  }

  Widget mcqItem(MCQData item, int index) {
    return Container(
      constraints: BoxConstraints(minHeight: 70, maxWidth: maxWidth(context)),
      child: Row(
        children: [
          Checkbox(
            checkColor: athensGray,
            activeColor: jungleGreen,
            // fillColor: MaterialStatePropertyAll(jungleGreen),
            value: questions.contains(item.id),
            onChanged: (value) => value != null
                ? setState(() {
                    if (value == true) {
                      questions = {...questions, item.id}.toList();
                    } else {
                      questions.remove(item.id);
                    }
                    // : questions
                    // ..remove(item.id);
                    // ..remove(item.id);
                  })
                : null,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              margin: EdgeInsets.symmetric(vertical: 4),
              // width: maxWidth(context),
              decoration: BoxDecoration(
                  color: raisingBlack, borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spacer(y: 10),
                  Container(
                      padding: EdgeInsets.all(10),
                      // foregroundDecoration: BoxDecoration(
                      // color: Colors.black, shape: BoxShape.circle),
                      decoration: BoxDecoration(
                          color: darkerShade, shape: BoxShape.circle),
                      child: Text('${index + 1} ', style: medium10)),
                  spacer(y: 10),
                  Text(item.query, style: small00),
                  spacer(y: 15),
                  Text('A. ${item.A}', style: mukta),
                  spacer(),
                  Text('B. ${item.B}', style: mukta),
                  spacer(),
                  Text('C. ${item.C}', style: mukta),
                  spacer(),
                  Text('D. ${item.D}', style: mukta),
                  spacer(y: 15),
                  Row(
                    children: [
                      Text('Correct Option', style: mukta),
                      spacer(),
                      Text(item.correct.name, style: medium10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          spacer(x: 15),
        ],
      ),
    );
  }

  Widget dcqItem(DCQData item, int index) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            checkColor: athensGray,
            activeColor: jungleGreen,
            value: questions.contains(item.id),
            onChanged: (value) => value != null
                ? setState(() {
                    if (value == true) {
                      questions = {...questions, item.id}.toList();
                    } else {
                      questions.remove(item.id);
                    }
                  })
                : null,
          ),
          spacer(),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: raisingBlack,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.query, style: small00),
                  spacer(),
                  Row(
                    children: [
                      Text('Correct', style: mukta),
                      spacer(),
                      Text(
                        item.correct.toString().toUpperCase(),
                        style: small10,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          spacer(x: 15),
        ],
      ),
    );
  }
}

Future<(bool, String, List<MCQData>, PageData)> _fetchMCQ(
    Dio dio, PageData page, int topicId) async {
  try {
    final res = await dio.get(APIUrl.fetchAllMcq.url,
        data: page.toJson(), queryParameters: {'topic_id': topicId});
    final {
      'detail': msg,
      'data': data,
      'page': fetchedPage,
      'has_next_page': hasNext
    } = res.data;
    return (
      res.statusCode == 200,
      msg.toString(),
      (data as List).map((e) => MCQData.fromJson(e)).toList(),
      PageData.fromJson(fetchedPage)..hasNextPage = hasNext,
      // hasNext
    );
  } catch (e) {
    return (false, e.toString(), <MCQData>[], page);
  }
}

Future<(bool, String, List<DCQData>, PageData)> _fetchDCQ(
    Dio dio, PageData page, int topicId) async {
  try {
    final res = await dio.get(APIUrl.fetchAllDcq.url,
        data: page.toJson(), queryParameters: {'topic_id': topicId});
    final {
      'detail': msg,
      'data': data,
      'page': fetchedPage,
      'has_next_page': hasNext
    } = res.data;
    return (
      res.statusCode == 200,
      msg.toString(),
      (data as List).map((e) => DCQData.fromJson(e)).toList(),
      PageData.fromJson(fetchedPage)..hasNextPage = hasNext
    );
  } catch (e) {
    return (false, e.toString(), <DCQData>[], page);
  }
}

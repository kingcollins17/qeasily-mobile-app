import 'package:dio/dio.dart';
import 'package:qeasily/model/question_model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:http/http.dart';

part 'create_question_util.g.dart';

Future<(bool status, String response, dynamic data)> addMCQuestions(
    Dio dio, List<MCQDraft> draft) async {
  try {
    //
    final (valid, indexes) = validateDraft(draft);
    if (!valid) {
      return (false, 'Draft is  invalid', indexes);
    }
    final res = await dio.post(
      APIUrl.createMcq.url,
      data: draft.map((e) => e.asMap()),
    );
    final {'detail': response as String} = res.data;

    return (res.statusCode == 200, response, null);
  } catch (e) {
    return (false, '$e', null);
  }
}

Future<(bool status, String msg, dynamic data)> addDCQuestions(
    Dio dio, List<DCQDraft> draft) async {
  try {
    final (valid, indexes) = validateDraft(draft);
    if (!valid) {
      return (false, 'Draft is invalid', indexes);
    } else {
      final res = await dio.post(
        APIUrl.createDcq.url,
        data: draft.map((e) => e.asMap()).toList(),
        // data: [draft[0].asMap()]
      );

      final {'detail': msg} = res.data;
      return (res.statusCode == 200, '$msg', null);
    }
  } catch (e) {
    return (false, '$e', null);
  }
}

///Returns whether this draft is valid and the indexes of the invalid Drafts in the list
(bool, List<int>) validateDraft(List<Draft> draft) {
  var valid = true;
  final invalidIndexex = <int>[];
  for (var i = 0; i < draft.length; i++) {
    valid = draft[i].isValid;

    ///Add to list of invalids
    if (!draft[i].isValid) invalidIndexex.add(i);
  }
  return (valid, invalidIndexex);
}

enum QType { mcq, dcq }

abstract class Draft {
  bool get isValid;
}

@JsonSerializable()
class MCQDraft extends Draft {
  String? query, A, B, C, D, explanation;
  MCQOption? correct;
  MCQDifficulty difficulty;
  int? topicId;

  @override
  bool get isValid =>
      query != null &&
      A != null &&
      B != null &&
      C != null &&
      D != null &&
      explanation != null &&
      correct != null &&
      topicId != null;

  MCQDraft({
    this.query,
    this.A,
    this.B,
    this.C,
    this.D,
    this.correct,
    this.explanation,
    this.topicId,
    this.difficulty = MCQDifficulty.easy,
  });

  factory MCQDraft.fromJson(Map<String, dynamic> json) =>
      _$MCQDraftFromJson(json);

  Map<String, dynamic> toJson() => _$MCQDraftToJson(this);

  Map<String, dynamic> asMap() => {
        'query': query,
        'A': A,
        'B': B,
        'C': C,
        'D': D,
        'correct': correct!.name,
        'explanation': explanation,
        'difficulty': difficulty.name,
        'topic_id': topicId
      };

  @override
  String toString() {
    return 'MCQDraft(query: $query, A: $A, B: $B, C: $C, D: $D, correct:'
        ' $correct, explanation: $explanation, topicId: $topicId)';
  }
}

enum MCQDifficulty { easy, medium, hard }

@JsonSerializable()
class DCQDraft extends Draft {
  String? query, explanation;
  bool correct;
  int? topicId;
  DCQDraft({this.query, this.explanation, this.correct = true, this.topicId});

  @override
  bool get isValid => query != null && explanation != null && topicId != null;

  factory DCQDraft.fromJson(Map<String, dynamic> json) =>
      _$DCQDraftFromJson(json);

  Map<String, dynamic> toJson() => _$DCQDraftToJson(this);

  @override
  String toString() {
    return 'DCQDraft{query, $query, explanation: $explanation,'
        ' correct: $correct, topicId: $topicId}';
  }

  Map<String, dynamic> asMap() => {
        'query': query,
        'correct': correct,
        'explanation': explanation,
        'topic_id': topicId
      };
}

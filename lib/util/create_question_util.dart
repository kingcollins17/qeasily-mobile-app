import 'package:dio/dio.dart';
import 'package:qeasily/model/question_model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
// import 'package:http/http.dart';

part 'create_question_util.g.dart';

Future<(bool status, String response, dynamic data)> publishMCQuestions(
    Dio dio, List<MCQDraft> draft) async {
  try {
    //
    final (valid, indexes) = validateDraft(draft);
    if (!valid) {
      return (false, 'Draft is  invalid', indexes);
    }
    final res = await dio.post(
      APIUrl.createMcq.url,
      data: draft.map((e) => e.asMap()).toList(),
    );
    final {'detail': response} = res.data;

    return (res.statusCode == 200, response.toString(), null);
  } catch (e) {
    return (false, '$e', null);
  }
}

Future<(bool status, String msg, dynamic data)> publishDCQuestions(
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

///Saves the MCQDraft to local storage
Future<void> saveMCQToStorage(
    {required List<MCQDraft> draft,
    required Box<List> box,
    required String draftName}) async {
  final data = draft.map((e) => e.toJson()).toList();
  return box.put(draftName, data);
}

///Loads the MCQDraft associated with the draftName from local storage
List<MCQDraft>? loadMCQFromStorage(Box<List> box, String draftName) {
  final data = box.get(draftName);
  return data?.map((e) => MCQDraft.fromJson(e)).toList();
}

Future<void> saveDCQToStorage(
    {required List<DCQDraft> draft,
    required Box<List> box,
    required String draftName}) async {
  final data = draft.map((e) => e.toJson()).toList();
  return box.put(draftName, data);
}

List<DCQDraft>? loadDCQFromStorage(Box<List> box, String draftName) {
  return box.get(draftName)?.map((e) => DCQDraft.fromJson(e)).toList();
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

enum QuestionType { mcq, dcq }

abstract interface class Draft {
  bool get isValid;
  // factory Draft.fromJson(Map<String, dynamic> json){}
}

// @HiveType(typeId: 1)
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
      (explanation != null) &&
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
  // NOTE: Change Map<String, dynamic> to just Map
  factory MCQDraft.fromJson(Map json) =>
      _$MCQDraftFromJson(json.cast<String, dynamic>());

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
        ' $correct, explanation: $explanation, topicId: $topicId, difficulty: $difficulty)';
  }
}

enum MCQDifficulty { easy, medium, hard }

// @HiveType(typeId: 2)
@JsonSerializable()
class DCQDraft extends Draft {
  String? query, explanation;
  bool correct;
  int? topicId;
  DCQDraft({this.query, this.explanation, this.correct = true, this.topicId});

  @override
  bool get isValid => query != null && explanation != null && topicId != null;

  factory DCQDraft.fromJson(Map json) =>
      _$DCQDraftFromJson(json.cast<String, dynamic>());

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

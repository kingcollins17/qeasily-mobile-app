import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
part 'follow_creators.g.dart';

@JsonSerializable()
class FollowAccountData {
  final int id;

  @JsonKey(name: 'user_name')
  final String userName;

  final String department, level;
  final int followers, topics;

  @JsonKey(name: 'total_quiz')
  final int totalQuiz;

  factory FollowAccountData.fromJson(Map<String, dynamic> json) =>
      _$FollowAccountDataFromJson(json);

  FollowAccountData(
      {required this.id,
      required this.userName,
      required this.department,
      required this.level,
      required this.followers,
      required this.topics,
      required this.totalQuiz});
  Map<String, dynamic> toJson() => _$FollowAccountDataToJson(this);

  @override
  toString() =>
      'FollowAccountData{id: $id, username: $userName, followers: $followers,'
      ' topics: $topics, totalQuiz: $totalQuiz, department: $department}';
}
// Future<dynamic>
Future<(bool, String, List<FollowAccountData>, PageData)> fetchAccountsToFollow(
    Dio dio, PageData page) async {
  try {
    final res = await dio.get(
      APIUrl.fetchAccountToFollow.url,
      data: page.toJson(),
    );

    final {
      'detail': msg,
      'data': data,
      'has_next_page': hasNext,
      'page': fetchedPage
    } = res.data;

    return (
      res.statusCode == 200,
      msg.toString(),
      (data as List).map((e) => FollowAccountData.fromJson(e)).toList(),
      PageData.fromJson(fetchedPage)..hasNextPage = hasNext
    );

    // return res;
  } catch (e) {
    return (false, e.toString(), <FollowAccountData>[], page);
  }
}

Future<(bool, String)> followCreator(Dio dio, int creatorId) async {
  try {
    final res = await dio.post(
      APIUrl.follow.url,
      queryParameters: {'id': creatorId},
    );

    final {'detail': msg} = res.data;
    return (res.statusCode == 200, msg.toString());
    // return res;
  } catch (e) {
    return (false, e.toString());
  }
}

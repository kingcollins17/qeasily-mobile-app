// ignore_for_file: unnecessary_this

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_state.g.dart';

@JsonSerializable()
class TopicState {

  @_PageConverter()
  PageData page;

  @_DataConverter()
  List<TopicData> topics;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoading = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? message;

  ///Holds the current selected categoryId
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? categoryId;
  //
  TopicState({PageData? page, this.topics = const []})
      : this.page = page ?? PageData(perPage: 6);

  factory TopicState.fromJson(Map<String, dynamic> json) =>
      _$TopicStateFromJson(json);

  Map<String, dynamic> toJson() => _$TopicStateToJson(this);

  @override
  toString() => 'TopicState{isLoading: $isLoading, page: $page, '
      'topics: $topics, message: $message, categorId: $categoryId}';
}

class _DataConverter extends JsonConverter<List<TopicData>, List<dynamic>> {
  const _DataConverter();
  @override
  List<TopicData> fromJson(List<dynamic> json) {
    return json.map((e) => TopicData.fromJson(e)).toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<TopicData> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

class _PageConverter extends JsonConverter<PageData, Map<String, dynamic>> {
  const _PageConverter();

  @override
  PageData fromJson(Map<String, dynamic> json) {
    return PageData.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(PageData object) {
    return object.toJson();
  }
}

typedef _Pholder0 = ({
  String detail,
  bool? hasNextPage,
  PageData? page,
  bool status,
  List<TopicData> topics
});

TopicState topicReducer(TopicState state, action) {
  if (action is TopicAction) {
    switch (action.type) {
      case TopicActionType.fetch:
        state
          ..isLoading = true
          ..message = 'Fetching topics';
        break;

      case TopicActionType.update:
        if (action.payload is _Pholder0) {
          final pd = action.payload as _Pholder0;
          state
            ..message = pd.detail
            ..isLoading = false
            ..page = pd.page ?? state.page
            ..topics = pd.status
                ? <TopicData>{...state.topics, ...pd.topics}.toList()
                : state.topics;
          state.page.hasNextPage = pd.hasNextPage ?? state.page.hasNextPage;
        }
        break;

      case TopicActionType.notify:
        state.message = action.payload.toString();
        break;
      case TopicActionType.silence:
        state
          ..message = null
          ..isLoading = false;
        break;
      case TopicActionType.reset:
        state
          ..message = null
          ..isLoading = false
          ..topics = []
          ..page = PageData(page: 0);
        break;
      case TopicActionType.selectCategory:
        if (action.payload is int) {
          state.categoryId = (action.payload as int);
          // ..page = PageData();
        }
        break;
      case TopicActionType.unselectCategory:
        state.categoryId = null;
        break;
      case TopicActionType.resetPage:
        state.page = PageData();
        break;
      default:
        break;
    }
  }
  return state;
}

class TopicVM {
  final Store _store;
  final TopicState state;
  TopicVM(store)
      : _store = store,
        state = store.state.topics;

  void dispatch(action) => _store.dispatch(action);
}

class TopicAction {
  final TopicActionType type;
  final Object? payload;

  TopicAction({required this.type, this.payload});
}

enum TopicActionType {
  fetch,
  nextPage,
  selectCategory,
  unselectCategory,
  notify,
  silence,
  search,
  update,
  reset,
  resetPage
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++===
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Future<
        ({
          List<TopicData> topics,
          String detail,
          bool status,
          PageData? page,
          bool? hasNextPage
        })>
    fetchTopics(Dio client, PageData page,
        {bool useFollowing = false, int? categoryId}) async {
  try {
    final res = await client.get(APIUrl.topics.url, data: {
      'page': page.page,
      'per_page': page.perPage
    }, queryParameters: {
      'following': useFollowing,
      if (categoryId != null) 'category': categoryId
    });
    final pageData =
        res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null;
    final hasNextPage = res.data['has_next_page'] as bool?;

    return (
      detail: res.data['detail'].toString(),
      status: res.statusCode == 200,
      topics: res.statusCode == 200
          ? (res.data['data'] as List)
              .map((e) => TopicData.fromJson(e))
              .toList()
          : <TopicData>[],
      page: pageData?..hasNextPage = hasNextPage ?? page.hasNextPage,
      hasNextPage: hasNextPage
    );
  } on Exception catch (e) {
    return (
      detail: e.toString(),
      topics: <TopicData>[],
      status: false,
      page: null,
      hasNextPage: null
    );
  }
}

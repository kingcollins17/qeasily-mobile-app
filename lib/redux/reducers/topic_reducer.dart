//+++++++++++++++++++++++++++++++++++++++++++++++++++++===
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';

import '../state/topic_state.dart';

TopicDataState topicReducer(TopicDataState state, action) {
  if (action is TopicAction) {
    switch (action.type) {
      case TopicActionType.fetch:
        state
          ..isLoading = true
          ..message = 'Fetching topics';
        break;

      case TopicActionType.update:
        if (action.payload is TopicFetchResponse) {
          final pd = action.payload as TopicFetchResponse;
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

typedef TopicFetchResponse = ({
  String detail,
  bool? hasNextPage,
  PageData? page,
  bool status,
  List<TopicData> topics
});

Future<
        ({
          List<TopicData> topics,
          String detail,
          bool status,
          PageData? page,
          bool? hasNextPage
        })>
    fetchTopics(Dio client, PageData page,
        {String? level, int? categoryId}) async {
  try {
    final res = await client
        .get(APIUrl.fetchTopics.url, data: page.toJson(), queryParameters: {
      if (level != null) 'level': level,
      if (categoryId != null) 'category_id': categoryId
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

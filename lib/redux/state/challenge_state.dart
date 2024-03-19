import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/route_doc.dart';
import 'package:redux/redux.dart';

class ChallengeState {
  PageData page;
  bool isLoading;
  List<ChallengeData> challenges;
  String? message;

  ChallengeState({this.message, this.challenges = const <ChallengeData>[]})
      : page = PageData(),
        isLoading = false;

  @override
  toString() =>
      'ChallengeState{page: $page, isLoading: $isLoading, data: $challenges, message: $message}';
}

final chgReducer = combineReducers([
  _netWorkReducer,
  _basicReducer,
]);

ChallengeState _netWorkReducer(ChallengeState state, action) {
  if (action is ChallengeAction) {
    switch (action.type) {
      case ChgActionType.fetch:
        state
          ..isLoading = true
          ..message = 'Fetching challenges';
        break;

      case ChgActionType.update:
        if (action.payload is ChgResp) {
          final pd = action.payload as ChgResp;
          state
            ..isLoading = false
            ..message = pd.detail
            ..challenges =
                <ChallengeData>{...state.challenges, ...pd.data}.toList()
            ..page = pd.page ?? state.page;
        }
        break;
      default:
        break;
    }
  }
  return state;
}

ChallengeState _basicReducer(ChallengeState state, action) {
  if (action is ChallengeAction) {
    switch (action.type) {
      case ChgActionType.notify:
        state.message = action.payload?.toString();
        break;
      case ChgActionType.reset:
        state
          ..message = null
          ..isLoading = false
          ..challenges = <ChallengeData>[]
          ..page = PageData();
        break;
      default:
        break;
    }
  }
  return state;
}

class ChallengeAction {
  final ChgActionType type;
  final Object? payload;

  ChallengeAction({required this.type, this.payload});
}

enum ChgActionType { fetch, update, notify, reset }

Future<ChgResp> fetchChallenges(Dio dio, PageData page) async {
  try {
    final res = await dio.get(APIUrl.fetchChallenges.url,
        data: page.toJson(), queryParameters: {'feed': false});

    final fetchedPage =
        res.statusCode == 200 ? PageData.fromJson(res.data['page']) : null;
    final hasNext = res.data['has_next_page'] as bool?;
    fetchedPage?.hasNextPage = hasNext ?? false;
    return (
      detail: res.data['detail'].toString(),
      data: res.statusCode == 200
          ? (res.data['challenges'] as List)
              .map((e) => ChallengeData.fromJson(e))
              .toList()
          : const <ChallengeData>[],
      page: fetchedPage,
      hasNextPage: hasNext
    );
    // return res;
  } catch (e) {
    return (
      detail: e.toString(),
      data: const <ChallengeData>[],
      page: null,
      hasNextPage: null
    );
  }
}

class ChallengeVM {
  final Store _store;
  final ChallengeState state;

  ChallengeVM(Store store)
      : _store = store,
        state = store.state.challenges;
  void dispatch(action) => _store.dispatch(action);
}

typedef ChgResp = ({
  String detail,
  List<ChallengeData> data,
  PageData? page,
  bool? hasNextPage
});

// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/provider/base.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_provider.g.dart';

@Riverpod(keepAlive: true)
class FollowNotifier extends _$FollowNotifier implements NextPageFetcher {
  @override
  Future<(List<ProfileData>, PageData)> build([bool followed = false]) async {
    final dio = ref.watch(generalDioProvider);
    if (followed) {
      final (status, msg, data, page) =
          await fetchFollowedAccounts(dio, PageData(page: 1));
      if (!status) throw msg;
      return (data, page);
    } else {
      final (status, msg, data, page) =
          await fetchAccountsToFollow(dio, PageData(page: 1));

      if (!status) throw msg;
      return (data, page);
    }
  }

  @override
  Future<(bool, String)> fetchNextPage() async {
    if (state.hasValue) {
      final (currentData, currentPage) = state.value!;
      if (currentPage.hasNextPage) {
        final dio = ref.read(generalDioProvider);
        final (status, msg, data, page) = switch (followed) {
          true => await fetchFollowedAccounts(dio, currentPage..next()),
          false => await fetchAccountsToFollow(dio, currentPage..next())
        };
        state = AsyncData((currentData..addAll(data), page)); //update state
        return (status, msg);
      } else {
        return (false, 'No next Page');
      }
    } else {
      return (false, 'No value for state');
    }
  }

  void remove(ProfileData account) {
    if (state.hasValue) {
      final (data, page) = state.value!;
      state = AsyncData((data..remove(account), page));
    }
  }
}

Future<(bool, String, List<ProfileData>, PageData)> fetchAccountsToFollow(
    Dio dio, PageData page) async {
  try {
    final res = await dio.get(
      APIUrl.fetchAccountToFollow.url,
      data: page.toJson(),
    );
    if (res.statusCode == 200) {
      final {
        'detail': msg,
        'data': data,
        'has_next_page': hasNext,
        'page': fetchedPage
      } = res.data;

      return (
        res.statusCode == 200,
        msg.toString(),
        (data as List).map((e) => ProfileData.fromJson(e)).toList(),
        PageData.fromJson(fetchedPage)..hasNextPage = hasNext
      );
    }

    return (false, res.data['detail'].toString(), <ProfileData>[], page);
  } catch (e) {
    return (false, e.toString(), <ProfileData>[], page);
  }
}

Future<(bool, String, List<ProfileData>, PageData)> fetchFollowedAccounts(
    Dio dio, PageData requestedPage) async {
  try {
    final res =
        await dio.get(APIUrl.fetchFollowings.url, data: requestedPage.toJson());

    if (res.statusCode == 200) {
      final {
        'detail': detail,
        'data': data,
        'has_next_page': hasNextPage,
        'page': page
      } = res.data;

      return (
        res.statusCode == 200,
        detail.toString(),
        (data as List).map((e) => ProfileData.fromJson(e)).toList(),
        PageData.fromJson(page)..hasNextPage = hasNextPage
      );
    } else {
      return (
        false,
        res.data['detail'].toString(),
        <ProfileData>[],
        requestedPage
      );
    }
  } catch (e) {
    return (false, e.toString(), <ProfileData>[], requestedPage);
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

Future<(bool, String)> unfollowCreator(Dio dio, int creatorId) async {
  try {
    final res = await dio
        .delete(APIUrl.unfollow.url, queryParameters: {'id': creatorId});

    return (res.statusCode == 200, res.data['detail'].toString());
  } catch (e) {
    return (false, e.toString());
  }
}

import 'package:dio/dio.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keys_provider.g.dart';

@Riverpod(keepAlive: true)
Future<APIKeyPair> apiKeys(ApiKeysRef ref) async {
  final dio = ref.watch(generalDioProvider);
  final (status, msg, keyPair) = await fetchAPIKeys(dio);
  if (!status) throw msg; //

  return keyPair!; //return the keypair
}

@JsonSerializable()
class APIKeyPair {
  @JsonKey(name: 'secret_key')
  final String secret;

  @JsonKey(name: 'public_key')
  final String public;
  factory APIKeyPair.fromJson(Map<String, dynamic> json) =>
      _$APIKeyPairFromJson(json);

  APIKeyPair({required this.secret, required this.public});
  Map<String, dynamic> toJson() => _$APIKeyPairToJson(this);

  @override
  toString() => 'APIKeys{secret: $secret, public: $public}';
}

Future<(bool, String, APIKeyPair?)> fetchAPIKeys(Dio dio) async {
  try {
    final response = await dio.get(APIUrl.fetchKeys.url);

    if (response.statusCode == 200) {
      return (
        true,
        response.data['detail'].toString(),
        APIKeyPair.fromJson(response.data)
      );
    }
    return (false, response.data['detail'].toString(), null);
  } catch (e) {
    return (false, e.toString(), null);
  }
}

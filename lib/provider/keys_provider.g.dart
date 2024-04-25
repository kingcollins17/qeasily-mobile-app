// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keys_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIKeyPair _$APIKeyPairFromJson(Map<String, dynamic> json) => APIKeyPair(
      secret: json['secret_key'] as String,
      public: json['public_key'] as String,
    );

Map<String, dynamic> _$APIKeyPairToJson(APIKeyPair instance) =>
    <String, dynamic>{
      'secret_key': instance.secret,
      'public_key': instance.public,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiKeysHash() => r'cd9bb5306fd69293ff47fd79e7edf57847a7d510';

/// See also [apiKeys].
@ProviderFor(apiKeys)
final apiKeysProvider = FutureProvider<APIKeyPair>.internal(
  apiKeys,
  name: r'apiKeysProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiKeysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiKeysRef = FutureProviderRef<APIKeyPair>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

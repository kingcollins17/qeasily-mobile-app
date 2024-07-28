// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingTransactionData _$PendingTransactionDataFromJson(
        Map<String, dynamic> json) =>
    PendingTransactionData(
      id: json['id'] as int,
      plan: json['plan'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,
      accessCode: json['access_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PendingTransactionDataToJson(
        PendingTransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan': instance.plan,
      'reference': instance.reference,
      'status': instance.status,
      'access_code': instance.accessCode,
      'created_at': instance.createdAt.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingTranxHash() => r'7918f328a8a6f98aec2c342272937f45f49d388f';

/// See also [PendingTranx].
@ProviderFor(PendingTranx)
final pendingTranxProvider = AutoDisposeAsyncNotifierProvider<PendingTranx,
    List<PendingTransactionData>>.internal(
  PendingTranx.new,
  name: r'pendingTranxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pendingTranxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingTranx = AutoDisposeAsyncNotifier<List<PendingTransactionData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

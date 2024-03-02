// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAuthHash() => r'd154e5089cb05045371b895a079ee25e4c5d235e';

/// See also [UserAuth].
@ProviderFor(UserAuth)
final userAuthProvider = AsyncNotifierProvider<UserAuth,
    ({UserData user, ProfileData? profile})>.internal(
  UserAuth.new,
  name: r'userAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserAuth = AsyncNotifier<({UserData user, ProfileData? profile})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

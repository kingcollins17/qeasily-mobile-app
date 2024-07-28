// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followNotifierHash() => r'063ad62e018ba06285bf159922a2b05a3ea8657a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FollowNotifier
    extends BuildlessAsyncNotifier<(List<ProfileData>, PageData)> {
  late final bool followed;

  FutureOr<(List<ProfileData>, PageData)> build([
    bool followed = false,
  ]);
}

/// See also [FollowNotifier].
@ProviderFor(FollowNotifier)
const followNotifierProvider = FollowNotifierFamily();

/// See also [FollowNotifier].
class FollowNotifierFamily
    extends Family<AsyncValue<(List<ProfileData>, PageData)>> {
  /// See also [FollowNotifier].
  const FollowNotifierFamily();

  /// See also [FollowNotifier].
  FollowNotifierProvider call([
    bool followed = false,
  ]) {
    return FollowNotifierProvider(
      followed,
    );
  }

  @override
  FollowNotifierProvider getProviderOverride(
    covariant FollowNotifierProvider provider,
  ) {
    return call(
      provider.followed,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'followNotifierProvider';
}

/// See also [FollowNotifier].
class FollowNotifierProvider extends AsyncNotifierProviderImpl<FollowNotifier,
    (List<ProfileData>, PageData)> {
  /// See also [FollowNotifier].
  FollowNotifierProvider([
    bool followed = false,
  ]) : this._internal(
          () => FollowNotifier()..followed = followed,
          from: followNotifierProvider,
          name: r'followNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followNotifierHash,
          dependencies: FollowNotifierFamily._dependencies,
          allTransitiveDependencies:
              FollowNotifierFamily._allTransitiveDependencies,
          followed: followed,
        );

  FollowNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.followed,
  }) : super.internal();

  final bool followed;

  @override
  FutureOr<(List<ProfileData>, PageData)> runNotifierBuild(
    covariant FollowNotifier notifier,
  ) {
    return notifier.build(
      followed,
    );
  }

  @override
  Override overrideWith(FollowNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowNotifierProvider._internal(
        () => create()..followed = followed,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        followed: followed,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<FollowNotifier, (List<ProfileData>, PageData)>
      createElement() {
    return _FollowNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowNotifierProvider && other.followed == followed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, followed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowNotifierRef
    on AsyncNotifierProviderRef<(List<ProfileData>, PageData)> {
  /// The parameter `followed` of this provider.
  bool get followed;
}

class _FollowNotifierProviderElement extends AsyncNotifierProviderElement<
    FollowNotifier, (List<ProfileData>, PageData)> with FollowNotifierRef {
  _FollowNotifierProviderElement(super.provider);

  @override
  bool get followed => (origin as FollowNotifierProvider).followed;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

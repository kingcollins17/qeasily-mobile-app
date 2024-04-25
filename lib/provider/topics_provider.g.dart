// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicsByCategoryHash() => r'97aa8664a50beac8b05db6d210f347f2c1a6387b';

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

abstract class _$TopicsByCategory
    extends BuildlessAutoDisposeAsyncNotifier<(List<TopicData>, PageData)> {
  late final int categoryId;
  late final String? level;

  FutureOr<(List<TopicData>, PageData)> build(
    int categoryId, [
    String? level,
  ]);
}

/// See also [TopicsByCategory].
@ProviderFor(TopicsByCategory)
const topicsByCategoryProvider = TopicsByCategoryFamily();

/// See also [TopicsByCategory].
class TopicsByCategoryFamily
    extends Family<AsyncValue<(List<TopicData>, PageData)>> {
  /// See also [TopicsByCategory].
  const TopicsByCategoryFamily();

  /// See also [TopicsByCategory].
  TopicsByCategoryProvider call(
    int categoryId, [
    String? level,
  ]) {
    return TopicsByCategoryProvider(
      categoryId,
      level,
    );
  }

  @override
  TopicsByCategoryProvider getProviderOverride(
    covariant TopicsByCategoryProvider provider,
  ) {
    return call(
      provider.categoryId,
      provider.level,
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
  String? get name => r'topicsByCategoryProvider';
}

/// See also [TopicsByCategory].
class TopicsByCategoryProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TopicsByCategory, (List<TopicData>, PageData)> {
  /// See also [TopicsByCategory].
  TopicsByCategoryProvider(
    int categoryId, [
    String? level,
  ]) : this._internal(
          () => TopicsByCategory()
            ..categoryId = categoryId
            ..level = level,
          from: topicsByCategoryProvider,
          name: r'topicsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topicsByCategoryHash,
          dependencies: TopicsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              TopicsByCategoryFamily._allTransitiveDependencies,
          categoryId: categoryId,
          level: level,
        );

  TopicsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.level,
  }) : super.internal();

  final int categoryId;
  final String? level;

  @override
  FutureOr<(List<TopicData>, PageData)> runNotifierBuild(
    covariant TopicsByCategory notifier,
  ) {
    return notifier.build(
      categoryId,
      level,
    );
  }

  @override
  Override overrideWith(TopicsByCategory Function() create) {
    return ProviderOverride(
      origin: this,
      override: TopicsByCategoryProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..level = level,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        level: level,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TopicsByCategory,
      (List<TopicData>, PageData)> createElement() {
    return _TopicsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicsByCategoryProvider &&
        other.categoryId == categoryId &&
        other.level == level;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, level.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TopicsByCategoryRef
    on AutoDisposeAsyncNotifierProviderRef<(List<TopicData>, PageData)> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;

  /// The parameter `level` of this provider.
  String? get level;
}

class _TopicsByCategoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TopicsByCategory,
        (List<TopicData>, PageData)> with TopicsByCategoryRef {
  _TopicsByCategoryProviderElement(super.provider);

  @override
  int get categoryId => (origin as TopicsByCategoryProvider).categoryId;
  @override
  String? get level => (origin as TopicsByCategoryProvider).level;
}

String _$createdTopicsHash() => r'1d9647a18de8e72ec61cb4b20171e6dc85f88ffb';

/// See also [CreatedTopics].
@ProviderFor(CreatedTopics)
final createdTopicsProvider =
    AsyncNotifierProvider<CreatedTopics, (List<TopicData>, PageData)>.internal(
  CreatedTopics.new,
  name: r'createdTopicsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createdTopicsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreatedTopics = AsyncNotifier<(List<TopicData>, PageData)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionsByCreatorHash() =>
    r'9ad7ff9e97572fea1590a14af21b45e3bc3be752';

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

abstract class _$QuestionsByCreator
    extends BuildlessAsyncNotifier<(List<Object> data, PageData page)> {
  late final QuestionType type;

  FutureOr<(List<Object> data, PageData page)> build(
    QuestionType type,
  );
}

/// See also [QuestionsByCreator].
@ProviderFor(QuestionsByCreator)
const questionsByCreatorProvider = QuestionsByCreatorFamily();

/// See also [QuestionsByCreator].
class QuestionsByCreatorFamily
    extends Family<AsyncValue<(List<Object> data, PageData page)>> {
  /// See also [QuestionsByCreator].
  const QuestionsByCreatorFamily();

  /// See also [QuestionsByCreator].
  QuestionsByCreatorProvider call(
    QuestionType type,
  ) {
    return QuestionsByCreatorProvider(
      type,
    );
  }

  @override
  QuestionsByCreatorProvider getProviderOverride(
    covariant QuestionsByCreatorProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'questionsByCreatorProvider';
}

/// See also [QuestionsByCreator].
class QuestionsByCreatorProvider extends AsyncNotifierProviderImpl<
    QuestionsByCreator, (List<Object> data, PageData page)> {
  /// See also [QuestionsByCreator].
  QuestionsByCreatorProvider(
    QuestionType type,
  ) : this._internal(
          () => QuestionsByCreator()..type = type,
          from: questionsByCreatorProvider,
          name: r'questionsByCreatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$questionsByCreatorHash,
          dependencies: QuestionsByCreatorFamily._dependencies,
          allTransitiveDependencies:
              QuestionsByCreatorFamily._allTransitiveDependencies,
          type: type,
        );

  QuestionsByCreatorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final QuestionType type;

  @override
  FutureOr<(List<Object> data, PageData page)> runNotifierBuild(
    covariant QuestionsByCreator notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(QuestionsByCreator Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuestionsByCreatorProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<QuestionsByCreator,
      (List<Object> data, PageData page)> createElement() {
    return _QuestionsByCreatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsByCreatorProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuestionsByCreatorRef
    on AsyncNotifierProviderRef<(List<Object> data, PageData page)> {
  /// The parameter `type` of this provider.
  QuestionType get type;
}

class _QuestionsByCreatorProviderElement extends AsyncNotifierProviderElement<
    QuestionsByCreator,
    (List<Object> data, PageData page)> with QuestionsByCreatorRef {
  _QuestionsByCreatorProviderElement(super.provider);

  @override
  QuestionType get type => (origin as QuestionsByCreatorProvider).type;
}

String _$questionsByTopicHash() => r'55a157fca985abc33ab94ab8fcf58607045a10c6';

abstract class _$QuestionsByTopic
    extends BuildlessAsyncNotifier<(List<Object>, PageData)> {
  late final int topicId;
  late final QuestionType type;

  FutureOr<(List<Object>, PageData)> build(
    int topicId, [
    QuestionType type = QuestionType.mcq,
  ]);
}

/// See also [QuestionsByTopic].
@ProviderFor(QuestionsByTopic)
const questionsByTopicProvider = QuestionsByTopicFamily();

/// See also [QuestionsByTopic].
class QuestionsByTopicFamily
    extends Family<AsyncValue<(List<Object>, PageData)>> {
  /// See also [QuestionsByTopic].
  const QuestionsByTopicFamily();

  /// See also [QuestionsByTopic].
  QuestionsByTopicProvider call(
    int topicId, [
    QuestionType type = QuestionType.mcq,
  ]) {
    return QuestionsByTopicProvider(
      topicId,
      type,
    );
  }

  @override
  QuestionsByTopicProvider getProviderOverride(
    covariant QuestionsByTopicProvider provider,
  ) {
    return call(
      provider.topicId,
      provider.type,
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
  String? get name => r'questionsByTopicProvider';
}

/// See also [QuestionsByTopic].
class QuestionsByTopicProvider extends AsyncNotifierProviderImpl<
    QuestionsByTopic, (List<Object>, PageData)> {
  /// See also [QuestionsByTopic].
  QuestionsByTopicProvider(
    int topicId, [
    QuestionType type = QuestionType.mcq,
  ]) : this._internal(
          () => QuestionsByTopic()
            ..topicId = topicId
            ..type = type,
          from: questionsByTopicProvider,
          name: r'questionsByTopicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$questionsByTopicHash,
          dependencies: QuestionsByTopicFamily._dependencies,
          allTransitiveDependencies:
              QuestionsByTopicFamily._allTransitiveDependencies,
          topicId: topicId,
          type: type,
        );

  QuestionsByTopicProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
    required this.type,
  }) : super.internal();

  final int topicId;
  final QuestionType type;

  @override
  FutureOr<(List<Object>, PageData)> runNotifierBuild(
    covariant QuestionsByTopic notifier,
  ) {
    return notifier.build(
      topicId,
      type,
    );
  }

  @override
  Override overrideWith(QuestionsByTopic Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuestionsByTopicProvider._internal(
        () => create()
          ..topicId = topicId
          ..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
        type: type,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<QuestionsByTopic, (List<Object>, PageData)>
      createElement() {
    return _QuestionsByTopicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsByTopicProvider &&
        other.topicId == topicId &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuestionsByTopicRef
    on AsyncNotifierProviderRef<(List<Object>, PageData)> {
  /// The parameter `topicId` of this provider.
  int get topicId;

  /// The parameter `type` of this provider.
  QuestionType get type;
}

class _QuestionsByTopicProviderElement extends AsyncNotifierProviderElement<
    QuestionsByTopic, (List<Object>, PageData)> with QuestionsByTopicRef {
  _QuestionsByTopicProviderElement(super.provider);

  @override
  int get topicId => (origin as QuestionsByTopicProvider).topicId;
  @override
  QuestionType get type => (origin as QuestionsByTopicProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

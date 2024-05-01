// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizByCreatorHash() => r'abd250235f4f1b6149ee09a02ef118aed6fff918';

/// See also [QuizByCreator].
@ProviderFor(QuizByCreator)
final quizByCreatorProvider =
    AsyncNotifierProvider<QuizByCreator, (List<QuizData>, PageData)>.internal(
  QuizByCreator.new,
  name: r'quizByCreatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizByCreatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuizByCreator = AsyncNotifier<(List<QuizData>, PageData)>;
String _$quizByTopicHash() => r'28e8dc3f92c0ca96e470d9f905fc0feb83b64a89';

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

abstract class _$QuizByTopic
    extends BuildlessAsyncNotifier<(List<QuizData>, PageData)> {
  late final int topicId;

  FutureOr<(List<QuizData>, PageData)> build(
    int topicId,
  );
}

/// See also [QuizByTopic].
@ProviderFor(QuizByTopic)
const quizByTopicProvider = QuizByTopicFamily();

/// See also [QuizByTopic].
class QuizByTopicFamily extends Family<AsyncValue<(List<QuizData>, PageData)>> {
  /// See also [QuizByTopic].
  const QuizByTopicFamily();

  /// See also [QuizByTopic].
  QuizByTopicProvider call(
    int topicId,
  ) {
    return QuizByTopicProvider(
      topicId,
    );
  }

  @override
  QuizByTopicProvider getProviderOverride(
    covariant QuizByTopicProvider provider,
  ) {
    return call(
      provider.topicId,
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
  String? get name => r'quizByTopicProvider';
}

/// See also [QuizByTopic].
class QuizByTopicProvider
    extends AsyncNotifierProviderImpl<QuizByTopic, (List<QuizData>, PageData)> {
  /// See also [QuizByTopic].
  QuizByTopicProvider(
    int topicId,
  ) : this._internal(
          () => QuizByTopic()..topicId = topicId,
          from: quizByTopicProvider,
          name: r'quizByTopicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizByTopicHash,
          dependencies: QuizByTopicFamily._dependencies,
          allTransitiveDependencies:
              QuizByTopicFamily._allTransitiveDependencies,
          topicId: topicId,
        );

  QuizByTopicProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
  }) : super.internal();

  final int topicId;

  @override
  FutureOr<(List<QuizData>, PageData)> runNotifierBuild(
    covariant QuizByTopic notifier,
  ) {
    return notifier.build(
      topicId,
    );
  }

  @override
  Override overrideWith(QuizByTopic Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizByTopicProvider._internal(
        () => create()..topicId = topicId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<QuizByTopic, (List<QuizData>, PageData)>
      createElement() {
    return _QuizByTopicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizByTopicProvider && other.topicId == topicId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuizByTopicRef on AsyncNotifierProviderRef<(List<QuizData>, PageData)> {
  /// The parameter `topicId` of this provider.
  int get topicId;
}

class _QuizByTopicProviderElement extends AsyncNotifierProviderElement<
    QuizByTopic, (List<QuizData>, PageData)> with QuizByTopicRef {
  _QuizByTopicProviderElement(super.provider);

  @override
  int get topicId => (origin as QuizByTopicProvider).topicId;
}

String _$quizByCategoryHash() => r'4dce3896d6725d58f13a4c55349b077de09fa6ae';

abstract class _$QuizByCategory
    extends BuildlessAsyncNotifier<(List<QuizData>, PageData)> {
  late final int categoryId;

  FutureOr<(List<QuizData>, PageData)> build(
    int categoryId,
  );
}

/// See also [QuizByCategory].
@ProviderFor(QuizByCategory)
const quizByCategoryProvider = QuizByCategoryFamily();

/// See also [QuizByCategory].
class QuizByCategoryFamily
    extends Family<AsyncValue<(List<QuizData>, PageData)>> {
  /// See also [QuizByCategory].
  const QuizByCategoryFamily();

  /// See also [QuizByCategory].
  QuizByCategoryProvider call(
    int categoryId,
  ) {
    return QuizByCategoryProvider(
      categoryId,
    );
  }

  @override
  QuizByCategoryProvider getProviderOverride(
    covariant QuizByCategoryProvider provider,
  ) {
    return call(
      provider.categoryId,
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
  String? get name => r'quizByCategoryProvider';
}

/// See also [QuizByCategory].
class QuizByCategoryProvider extends AsyncNotifierProviderImpl<QuizByCategory,
    (List<QuizData>, PageData)> {
  /// See also [QuizByCategory].
  QuizByCategoryProvider(
    int categoryId,
  ) : this._internal(
          () => QuizByCategory()..categoryId = categoryId,
          from: quizByCategoryProvider,
          name: r'quizByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizByCategoryHash,
          dependencies: QuizByCategoryFamily._dependencies,
          allTransitiveDependencies:
              QuizByCategoryFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  QuizByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  FutureOr<(List<QuizData>, PageData)> runNotifierBuild(
    covariant QuizByCategory notifier,
  ) {
    return notifier.build(
      categoryId,
    );
  }

  @override
  Override overrideWith(QuizByCategory Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizByCategoryProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<QuizByCategory, (List<QuizData>, PageData)>
      createElement() {
    return _QuizByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizByCategoryProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuizByCategoryRef
    on AsyncNotifierProviderRef<(List<QuizData>, PageData)> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _QuizByCategoryProviderElement extends AsyncNotifierProviderElement<
    QuizByCategory, (List<QuizData>, PageData)> with QuizByCategoryRef {
  _QuizByCategoryProviderElement(super.provider);

  @override
  int get categoryId => (origin as QuizByCategoryProvider).categoryId;
}

String _$suggestedQuizHash() => r'23662825dd32d2de2df198ab264c0e14f30eb46f';

/// See also [SuggestedQuiz].
@ProviderFor(SuggestedQuiz)
final suggestedQuizProvider =
    AsyncNotifierProvider<SuggestedQuiz, (List<QuizData>, PageData)>.internal(
  SuggestedQuiz.new,
  name: r'suggestedQuizProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$suggestedQuizHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SuggestedQuiz = AsyncNotifier<(List<QuizData>, PageData)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

// const _perPage = 10;

@JsonSerializable()
class PageData {
  int page;

  @JsonKey(name: 'per_page')
  int perPage;

  @JsonKey(includeFromJson: false)
  bool hasNextPage;

  factory PageData.fromJson(Map<String, dynamic> json) =>
      _$PageDataFromJson(json);

  PageData({this.page = 0, this.perPage = 10, this.hasNextPage = true});
  Map<String, dynamic> toJson() => _$PageDataToJson(this);

  @override
  String toString() =>
      'Page{page: $page, perPage: $perPage, hasNext: $hasNextPage}';

  PageData operator +(int i) {
    page += i;
    return this;
  }

  void next() {
    page += 1;
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class TopicData {
  final int id;
  final String title, description;

  @JsonKey(name: 'date_added')
  final DateTime dateAdded;

  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'user_id')
  final int userId;

  final String level;

  factory TopicData.fromJson(Map<String, dynamic> json) =>
      _$TopicDataFromJson(json);

  TopicData(
      {required this.id,
      required this.title,
      required this.description,
      required this.dateAdded,
      required this.categoryId,
      required this.userId,
      required this.level});
  Map<String, dynamic> toJson() => _$TopicDataToJson(this);

  @override
  bool operator ==(Object other) {
    return (other is TopicData) &&
        (identical(this, other) ||
            ((id == other.id) &&
                title == other.title &&
                dateAdded == other.dateAdded));
  }

  @override
  String toString() =>
      'TopicData{id: $id, title: $title,  description: $description, date: $dateAdded, categoryId: $categoryId}';

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

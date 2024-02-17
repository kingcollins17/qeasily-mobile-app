import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class AppConfig extends HiveObject {

  @HiveField(0)
  bool darkMode = false;
}

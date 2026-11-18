import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final String genre;

  @HiveField(4)
  final String platform;

  @HiveField(5)
  final String email;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.email,
  });
}
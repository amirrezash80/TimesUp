import 'package:uuid/uuid.dart';

class PlayersInfo {
  final String id; // Add a unique ID for each player
  String name;
  int points = 0;

  PlayersInfo({String? id, required this.name, required this.points})
      : id = id ?? Uuid().v4(); // Generate a unique ID if not provided
}

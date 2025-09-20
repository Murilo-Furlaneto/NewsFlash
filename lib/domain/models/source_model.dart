import 'package:hive/hive.dart';

part 'source_model.g.dart';

@HiveType(typeId: 1)
class Source {
    @HiveField(0)
  final String? id;
    @HiveField(1)

  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ContestListItem {
  final int pk;
  final String key;
  final String name;
  final String topic;
  final DateTime startTime;
  final DateTime endTime;

  ContestListItem({
    required this.pk,
    required this.key,
    required this.name,
    required this.topic,
    required this.startTime,
    required this.endTime,
  });

  String get title => '$name - $topic';

  factory ContestListItem.fromJson(Map<String, dynamic> json) {
    return ContestListItem(
      pk: json['pk'],
      key: json['key'],
      name: json['name'],
      topic: json['topic'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}

class ContestDetailResponse extends ContestListItem {
  final String description;
  final int userCount;

  ContestDetailResponse({
    required super.pk,
    required super.key,
    required super.name,
    required super.topic,
    required super.startTime,
    required super.endTime,
    required this.description,
    required this.userCount,
  });

  factory ContestDetailResponse.fromJson(Map<String, dynamic> json) {
    return ContestDetailResponse(
      pk: json['pk'],
      key: json['key'],
      name: json['name'],
      topic: json['topic'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      description: json['description'],
      userCount: json['user_count'],
    );
  }
}

class ContestResponse {
  final int? pk;

  ContestResponse({this.pk});

  bool get hasContest => pk != null;

  factory ContestResponse.fromJson(Map<String, dynamic> json) {
    return ContestResponse(pk: json['pk'] as int?);
  }
}

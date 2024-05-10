class Log {
  final int id;
  final String log;
  final String date;

  Log({
    required this.id,
    required this.log,
    required this.date,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      log: json['log'],
      date: DateTime.parse(json['created_at']).toString().split(" ")[0],
    );
  }
}

final List<Log> logs = [];

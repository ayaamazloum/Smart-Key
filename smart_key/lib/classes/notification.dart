class MyNotification {
  final int id;
  final String text;
  final bool read;
  final String date;

  MyNotification({
    required this.id,
    required this.text,
    required this.read,
    required this.date,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      id: json['id'],
      text: json['text'],
      read: json['read'] == 1,
      date: DateTime.parse(json['created_at']).toString().substring(0, 16),
    );
  }
}

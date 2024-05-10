class Invitation {
  final int id;
  final String email;
  final String type;

  Invitation({
    required this.id,
    required this.email,
    required this.type,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'],
      email: json['email'],
      type: json['type']
    );
  }
}

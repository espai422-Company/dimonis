import 'dart:convert';

class FirebaseUser {
  final String email;
  final String providerId;
  final String id;

  String displayName;
  String photoUrl;
  String privileges;

  FirebaseUser({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.providerId,
    required this.privileges,
    required this.id,
  });

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromMap(Map<String, dynamic> json, String id) =>
      FirebaseUser(
        email: json["email"],
        displayName: json["displayName"],
        photoUrl: json["photoURL"],
        providerId: json["providerId"],
        privileges: json["privileges"],
        id: id,
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "displayName": displayName,
        "photoURL": photoUrl,
        "providerId": providerId,
        "privileges": privileges,
      };
}

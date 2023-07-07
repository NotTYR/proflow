import 'package:ProFlow/navigation/student/text%20and%20voice/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final String urlAvatar;
  final DateTime lastMessageTime;

  const User({
    required this.idUser,
    required this.name,
    required this.urlAvatar,
    required this.lastMessageTime,
  });

  User copyWith({
    required String idUser,
    required String name,
    required String urlAvatar,
    required DateTime
        lastMessageTime, // Fix: Changed type from String to DateTime
  }) =>
      User(
        idUser: idUser,
        name: name,
        urlAvatar: urlAvatar,
        lastMessageTime: lastMessageTime,
      );

  static User fromJson(Map<String, dynamic> json) => User(
      idUser: json['idUser'],
      name: json['name'],
      urlAvatar: json['urlAvatar'],
      lastMessageTime:
          json[UserField.lastMessageTime]); // Fix: Added UserField prefix

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        UserField.lastMessageTime: Utils.fromDateTimeToJson(
            lastMessageTime), // Fix: Added UserField prefix
      };
}

import 'dart:async';

import 'package:ProFlow/navigation/student/text%20and%20voice/data.dart';
import 'package:ProFlow/navigation/student/text%20and%20voice/message.dart';
import 'package:ProFlow/navigation/student/text%20and%20voice/user.dart';
import 'package:ProFlow/navigation/student/text%20and%20voice/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Stream<List<User>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(User.fromJson as StreamTransformer<
          QuerySnapshot<Map<String, dynamic>>, List<User>>);

  static Future<void> uploadMessage(String idUser, String message) async {
    // Fix: Added void return type
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');

    final newMessage = Message(
      idUser: myId,
      urlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Message.fromJson as StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, List<Message>>);

  static Future<void> addRandomUsers(List<User> users) async {
    // Fix: Added void return type
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      throw Exception(
          'Random users already added.'); // Fix: Throwing an exception instead of returning a QuerySnapshot
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(
            idUser: userDoc.id,
            lastMessageTime: DateTime.now(),
            name: '',
            urlAvatar: ''); // Fix: Set lastMessageTime to a non-empty string

        await userDoc.set(newUser.toJson());
      }
    }
  }
}

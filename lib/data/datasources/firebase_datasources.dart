import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trial_chat/data/model/channel_model.dart';
import 'package:trial_chat/data/model/message_model.dart';
import 'package:trial_chat/data/model/user_model.dart';

String channelId(String id1, String id2) {
  if (id1.hashCode < id2.hashCode) {
    return '$id1-$id2';
  } else {
    return '$id2-$id1';
  }
}

class FirebaseDatasources {
  FirebaseDatasources._init();

  static final FirebaseDatasources instance = FirebaseDatasources._init();

  Stream<List<UserModel>> allUser() {
    return FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .map((snapshot) {
      List<UserModel> rs = [];
      for (var element in snapshot.docs) {
        rs.add(UserModel.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }

  Stream<List<Channel>> channelStream(String userId) {
    return FirebaseFirestore.instance
        .collection('channels')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Channel> rs = [];
      for (var element in querySnapshot.docs) {
        rs.add(Channel.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }

  Future<void> updateChannel(
    String channelId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addMessage(Message message) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> messageStream(String channelId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('channelId', isEqualTo: channelId)
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Message> rs = [];
      for (var element in querySnapshot.docs) {
        rs.add(Message.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }

  
}

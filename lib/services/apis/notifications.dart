import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

import '../../models/notifications.dart';

class NotificationApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // ADD
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('notifications');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "unique_id": payload["unique_id"],
      "type": payload["type"],
      "date": payload["date"],
      "time": payload["time"],
      "content": payload["content"],
      "owner_type": payload["owner_type"],
      "is_read": "0",
      "is_showed": "0",
      "created_at": "${DateTime.now()}",
      "sender": payload["sender"],
      "receiver": payload["receiver"]
    });
  }

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('notifications');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          notificationModel.update(data: data.values.where((s) => s["receiver"] == "admin").toList());
          notificationModel.updateSearch(data: data.values.where((s) => s["receiver"] == "admin").toList());
        } else if (data is List) {
          notificationModel.update(data: data.where((s) => s["receiver"] == "admin").toList());
          notificationModel.updateSearch(data: data.where((s) => s["receiver"] == "admin").toList());
        }
      } else {
        notificationModel.update(data: []);
        notificationModel.updateSearch(data: []);

      }
    });
  }

  Future showed({required String id})async{
    DatabaseReference usersRef = database.ref('notifications');
    FirebaseDatabase.instance.ref().child('notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_showed": "1",
      });
    });
  }

  Future seen({required String id})async{
    DatabaseReference usersRef = database.ref('notifications');
    FirebaseDatabase.instance.ref().child('notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_read": "1",
      });
    });
  }
}
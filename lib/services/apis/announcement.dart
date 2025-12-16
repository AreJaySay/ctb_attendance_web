import 'package:ctb_attendance_monitoring/models/announcements.dart';
import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:firebase_database/firebase_database.dart';

class AnnouncementApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // GET ANNOUNCEMENTS
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('announcements');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          announcementsModel.update(data: data.values.toList());
          announcementsModel.updateSearch(data: data.values.toList());
          print("ANNOUNCEMENTS ${data.values.toList()}");
        } else if (data is List) {
          announcementsModel.update(data: data);
          announcementsModel.updateSearch(data: data);
        }
      } else {
        announcementsModel.update(data: []);
        announcementsModel.updateSearch(data: []);
      }
    });
  }
  // ADD ANNOUNCEMENT
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('announcements');
    await usersRef.push().set({
      "unique_id": payload["unique_id"],
      "type": payload["type"],
      "date": payload["date"],
      "time": payload["time"],
      "content": payload["content"],
      "owner_type": payload["owner_type"],
    });
  }
  // EDIT ANNOUNCEMENT
  Future edit({required String old_school_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('announcements');
    FirebaseDatabase.instance.ref().child('announcements').orderByChild("unique_id").equalTo(old_school_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/unique_id": payload["unique_id"],
        "${event.snapshot.key!}/type": payload["type"],
        "${event.snapshot.key!}/date": payload["date"],
        "${event.snapshot.key!}/time": payload["time"],
        "${event.snapshot.key!}/content": payload["content"],
        "${event.snapshot.key!}/owner_type": payload["owner_type"],
      });
    });
  }
  // DELETE ANNOUNCEMENT
  Future delete({required String school_id})async{
    FirebaseDatabase.instance.ref().child('announcements').orderByChild("unique_id").equalTo(school_id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("announcements/${event.snapshot.key!}");
      await ref.remove();
    });
  }
}


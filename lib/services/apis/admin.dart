import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:ctb_attendance_monitoring/models/admin.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('admin');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          adminModel.update(data: data.values.toList());
          print("ADMIN ${data.values.toList()}");
        } else if (data is List) {
          adminModel.update(data: data);
        }
      } else {
        adminModel.update(data: []);
      }
    });
  }

  // ADD ADMIN
  Future addAdmin({required Map payload})async{
    DatabaseReference usersRef = database.ref('admin');
    await usersRef.push().set({
      "type": "admin",
      "fname": payload["fname"],
      "lname": payload["lname"],
      "age": payload["age"],
      "admin_id": payload["admin_id"],
      "gender": payload["gender"],
      "subject": payload["subject"],
      "phone": payload["phone"],
      "email": payload["email"],
      "pass": payload["pass"],
      "base64Image": payload["base64Image"],
    });
  }
  // EDIT ADMIN
  Future editAdmin({required String old_teacher_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('admin');
    FirebaseDatabase.instance.ref().child('admin').orderByChild("admin_id").equalTo(old_teacher_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/fname": payload["fname"],
        "${event.snapshot.key!}/lname": payload["lname"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/admin_id": payload["admin_id"],
        "${event.snapshot.key!}/gender": payload["gender"],
        "${event.snapshot.key!}/subject": payload["subject"],
        "${event.snapshot.key!}/phone": payload["phone"],
        "${event.snapshot.key!}/email": payload["email"],
        "${event.snapshot.key!}/pass": payload["pass"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }
}


import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:firebase_database/firebase_database.dart';

class TeacherApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('teachers');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          teachersModel.update(data: data.values.toList());
          print("TEACHERS ${data.values.toList()}");
        } else if (data is List) {
          teachersModel.update(data: data);
        }
      } else {
        teachersModel.update(data: []);
      }
    });
  }
  // ADD TEACHER
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('teachers');
    await usersRef.push().set({
      "name": payload["name"],
      "age": payload["age"],
      "teacher_id": payload["teacher_id"],
      "department": payload["department"],
      "year": payload["year"],
      "base64Image": payload["base64Image"],
    });
  }
  // EDIT TEACHER
  Future edit({required String old_teacher_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('teachers');
    FirebaseDatabase.instance.ref().child('teachers').orderByChild("teacher_id").equalTo(old_teacher_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/name": payload["name"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/teacher_id": payload["teacher_id"],
        "${event.snapshot.key!}/department": payload["department"],
        "${event.snapshot.key!}/year": payload["year"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }
  // DELETE TEACHER
  Future delete({required String teacher_id})async{
    FirebaseDatabase.instance.ref().child('teachers').orderByChild("teacher_id").equalTo(teacher_id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("teachers/${event.snapshot.key!}");
      await ref.remove();
    });
  }
}


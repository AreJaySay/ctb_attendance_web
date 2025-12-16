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
          teachersModel.updateSearch(data: data.values.toList());
          print("TEACHERS ${data.values.toList()}");
        } else if (data is List) {
          teachersModel.update(data: data);
          teachersModel.updateSearch(data: data);
        }
      } else {
        teachersModel.update(data: []);
        teachersModel.updateSearch(data: []);
      }
    });
  }
  // ADD TEACHER
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('teachers');
    await usersRef.push().set({
      "type": "teacher",
      "fname": payload["fname"],
      "lname": payload["lname"],
      "age": payload["age"],
      "teacher_id": payload["teacher_id"],
      "gender": payload["gender"],
      "subject": payload["subject"],
      "phone": payload["phone"],
      "email": payload["email"],
      "pass": payload["pass"],
      "students_handled_grade": payload["students_handled_grade"],
      "students_handled_section": payload["students_handled_section"],
      "base64Image": payload["base64Image"],
      "status": "pending",
    });
  }
  // EDIT TEACHER
  Future edit({required String old_teacher_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('teachers');
    FirebaseDatabase.instance.ref().child('teachers').orderByChild("teacher_id").equalTo(old_teacher_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/fname": payload["fname"],
        "${event.snapshot.key!}/lname": payload["lname"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/teacher_id": payload["teacher_id"],
        "${event.snapshot.key!}/gender": payload["gender"],
        "${event.snapshot.key!}/subject": payload["subject"],
        "${event.snapshot.key!}/phone": payload["phone"],
        "${event.snapshot.key!}/email": payload["email"],
        "${event.snapshot.key!}/students_handled_grade": payload["students_handled_grade"],
        "${event.snapshot.key!}/students_handled_section": payload["students_handled_section"],
        "${event.snapshot.key!}/pass": payload["pass"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
        "${event.snapshot.key!}/status": payload["status"],
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

  // ADD MEETING
  Future addMeeting({required Map payload})async{
    DatabaseReference usersRef = database.ref('meeting');
    await usersRef.push().set({
      "venue": payload["venue"],
      "date": payload["date"],
      "start_time": payload["start_time"],
      "end_time": payload["end_time"],
      "content": payload["content"],
    });
  }
}

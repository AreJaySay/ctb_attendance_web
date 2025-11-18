import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // GET STUDENTS
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('students');
      ref.onValue.listen((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.exists) {
          final data = dataSnapshot.value;
          if (data is Map) {
            studentsModel.update(data: data.values.toList());
            print("STUDENTS ${data.values.toList()}");
          } else if (data is List) {
            studentsModel.update(data: data);
          }
        } else {
          studentsModel.update(data: []);
        }
    });
  }
  // ADD STUDENT
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('students');
    await usersRef.push().set({
      "name": payload["name"],
      "age": payload["age"],
      "school_id": payload["school_id"],
      "department": payload["department"],
      "year": payload["year"],
      "section": payload["section"],
      "base64Image": payload["base64Image"],
    });
  }
  // EDIT STUDENT
  Future edit({required String old_school_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('students');
    FirebaseDatabase.instance.ref().child('students').orderByChild("school_id").equalTo(old_school_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/name": payload["name"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/school_id": payload["school_id"],
        "${event.snapshot.key!}/department": payload["department"],
        "${event.snapshot.key!}/year": payload["year"],
        "${event.snapshot.key!}/section": payload["section"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }
  // DELETE STUDENT
  Future delete({required String school_id})async{
    FirebaseDatabase.instance.ref().child('students').orderByChild("school_id").equalTo(school_id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("students/${event.snapshot.key!}");
      await ref.remove();
    });
  }
}


import 'dart:math';

import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/user.dart';

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
            if(userModel.loggedUser.value["type"] == "teacher"){
              studentsModel.updateSearch(data: data.values.toList().where((s) => s["year"] == userModel.loggedUser.value["students_handled_grade"] && s["section"] == userModel.loggedUser.value["students_handled_section"]).toList());
              studentsModel.update(data: data.values.toList().where((s) => s["year"] == userModel.loggedUser.value["students_handled_grade"] && s["section"] == userModel.loggedUser.value["students_handled_section"]).toList());
            }else{
              studentsModel.updateSearch(data: data.values.toList());
              studentsModel.update(data: data.values.toList());
            }
          } else if (data is List) {
            if(userModel.loggedUser.value["type"] == "teacher"){
              studentsModel.updateSearch(data: data.where((s) => s["year"] == userModel.loggedUser.value["students_handled_grade"] && s["section"] == userModel.loggedUser.value["students_handled_section"]).toList());
              studentsModel.update(data: data.where((s) => s["year"] == userModel.loggedUser.value["students_handled_grade"] && s["section"] == userModel.loggedUser.value["students_handled_section"]).toList());
            }else{
              studentsModel.updateSearch(data: data);
              studentsModel.update(data: data);
            }
          }
        } else {
          studentsModel.update(data: []);
          studentsModel.updateSearch(data: []);
        }
    });
  }
  // ADD STUDENT
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('students');
    await usersRef.push().set({
      "unique_id": "${10000 + Random().nextInt(90000)}",
      "name": payload["name"],
      "age": payload["age"],
      "lrn": payload["lrn"],
      "phone": payload["phone"],
      "gender": payload["gender"],
      "year": payload["year"],
      "section": payload["section"],
      "base64Image": payload["base64Image"],
    });
  }
  // EDIT STUDENT
  Future edit({required String old_school_id,required Map payload})async{
    DatabaseReference usersRef = database.ref('students');
    FirebaseDatabase.instance.ref().child('students').orderByChild("lrn").equalTo(old_school_id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/name": payload["name"],
        "${event.snapshot.key!}/age": payload["age"],
        "${event.snapshot.key!}/lrn": payload["lrn"],
        "${event.snapshot.key!}/phone": payload["phone"],
        "${event.snapshot.key!}/gender": payload["gender"],
        "${event.snapshot.key!}/year": payload["year"],
        "${event.snapshot.key!}/section": payload["section"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }
  // DELETE STUDENT
  Future delete({required String school_id})async{
    FirebaseDatabase.instance.ref().child('students').orderByChild("lrn").equalTo(school_id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("students/${event.snapshot.key!}");
      await ref.remove();
    });
  }
}


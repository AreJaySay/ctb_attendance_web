import 'dart:convert';
import 'dart:math';
import 'package:ctb_attendance_monitoring/models/reports.dart';
import 'package:ctb_attendance_monitoring/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../../models/notifications.dart';


class ReportsApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // GET
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('reports');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          if(userModel.loggedUser.value["type"] == "teacher"){
            reportsModel.updateSearch(data: data.values.toList().where((s) => s["student_year"] == userModel.loggedUser.value["students_handled_grade"] && s["student_section"] == userModel.loggedUser.value["students_handled_section"] && s["receiver"] == "teacher").toList());
            reportsModel.update(data: data.values.toList().where((s) => s["student_year"] == userModel.loggedUser.value["students_handled_grade"] && s["student_section"] == userModel.loggedUser.value["students_handled_section"] && s["receiver"] == "teacher").toList());
          }else{
            if(userModel.loggedUser.value["type"] == "teacher"){
              reportsModel.updateSearch(data: data.values.where((s) => s["student_year"] == userModel.loggedUser.value["students_handled_grade"] && s["student_section"] == userModel.loggedUser.value["students_handled_section"] && s["receiver"] == "teacher").toList());
              reportsModel.update(data: data.values.where((s) => s["student_year"] == userModel.loggedUser.value["students_handled_grade"] && s["student_section"] == userModel.loggedUser.value["students_handled_section"] && s["receiver"] == "teacher").toList());
            }else{
              reportsModel.update(data: data.values.toList());
              reportsModel.updateSearch(data: data.values.toList());
            }
          }
          print("REPORTS $data");
        } else if (data is List) {
          reportsModel.update(data: data);
          reportsModel.updateSearch(data: data);
        }
      } else {
        reportsModel.update(data: []);
        reportsModel.updateSearch(data: []);

      }
    });
  }

  // ADD
  Future add({required Map payload})async{
    DatabaseReference usersRef = database.ref('reports');
    await usersRef.push().set({
      "email": "",
      "type": payload["type"],
      "content": payload["content"],
      "guardian_id": "",
      "guardian": "",
      "student_name": payload["student_name"],
      "student_year": payload["student_year"],
      "student_section": payload["student_section"],
      "sender": "teacher",
      "receiver": "guardian",
      "created_at": "${DateFormat.yMMMd().format(DateTime.now())}",
      "time": "${DateTime.now()}"
    });
  }
}
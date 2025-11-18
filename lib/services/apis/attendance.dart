import 'package:ctb_attendance_monitoring/models/attendance.dart';
import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:firebase_database/firebase_database.dart';

class AttendanceApis{
  Future getAttendances() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          attendanceModel.update(data: data.values.toList());
          print("ATTENDANCE ${data.values.toList()}");
        } else if (data is List) {
          attendanceModel.update(data: data);
        }
      } else {
        attendanceModel.update(data: []);
      }
    });
  }
}


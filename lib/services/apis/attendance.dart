import 'package:ctb_attendance_monitoring/models/attendance.dart';
import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AttendanceApis{
  Future getAttendances() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendances');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          List _res = [];

          final grouped = groupById(data.values.toList());
          List<dynamic> mapList = convertToMapList(grouped);
          for(int x = 0; x < mapList.length; x++){
            _res.add([mapList[x]["items"].first,mapList[x]["items"].last]);
          }
          print("ATTENDANCE ${_res}");
          attendanceModel.update(data: _res);
          attendanceModel.updateSearch(data: _res);
        } else if (data is List) {
          attendanceModel.update(data: data);
          attendanceModel.updateSearch(data: data);
        }
      } else {
        attendanceModel.update(data: []);
        attendanceModel.updateSearch(data: []);
      }
    });
  }
  Map<String, List> groupById(List items) {
    final Map<String, List> grouped = {};
    for (var item in items) {
      final key = "${item['unique_id']}|${DateFormat.yMMMd().format(DateTime.parse(item['date_time']))}";
      grouped[key] == null && ((grouped[key] = []) != null);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  List convertToMapList(grouped) {
    return grouped.entries.map((entry) {
      return {
        "id": entry.key,
        "items": entry.value,   // You can also map to JSON if needed
      };
    }).toList();
  }
}


import 'package:rxdart/rxdart.dart';

class AttendanceModel{
  // ATTENDANCES
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
    search.add(data);
  }

  // TO SEARCH
  BehaviorSubject<List> search = new BehaviorSubject();
  Stream get streamSearch => search.stream;
  List get valueSearch => search.value;
}
final AttendanceModel attendanceModel = new AttendanceModel();
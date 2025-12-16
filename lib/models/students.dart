import 'package:rxdart/rxdart.dart';

class StudentsModel{
  // ALL STUDENTS
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
  }

  // TO SEARCH
  BehaviorSubject<List> search = new BehaviorSubject();
  Stream get streamSearch => search.stream;
  List get valueSearch => search.value;

  updateSearch({required List data}){
    search.add(data);
  }
}
final StudentsModel studentsModel = new StudentsModel();
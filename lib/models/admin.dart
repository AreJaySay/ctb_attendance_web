import 'package:rxdart/rxdart.dart';

class AdminModel{
  // ALL ADMIN
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
  }
}
final AdminModel adminModel = new AdminModel();
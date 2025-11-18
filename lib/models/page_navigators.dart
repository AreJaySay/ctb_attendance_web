import 'package:rxdart/rxdart.dart';

class PageNavigatorsModel{
  // NOTIFICATION PAGE CHECKER
  BehaviorSubject<bool> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  bool get value => subject.value;

  update({required bool data}){
    subject.add(data);
  }
}
final PageNavigatorsModel pageNavigatorsModel = new PageNavigatorsModel();
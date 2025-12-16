import 'package:rxdart/rxdart.dart';

class PageNavigatorsModel{
  // NOTIFICATION PAGE CHECKER
  BehaviorSubject<String> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  String get value => subject.value;

  update({required String data}){
    subject.add(data);
  }
}
final PageNavigatorsModel pageNavigatorsModel = new PageNavigatorsModel();
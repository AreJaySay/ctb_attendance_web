import 'package:rxdart/rxdart.dart';

class UsersModel{
  // ALL USERS
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
  }

  // CURRENT USERS
  BehaviorSubject<Map> loggedUser = new BehaviorSubject();
  Stream get streamLogged => loggedUser.stream;
  Map get valueLogged => loggedUser.value;

  updateUser({required Map data}){
    loggedUser.add(data);
  }
}
final UsersModel usersModel = new UsersModel();
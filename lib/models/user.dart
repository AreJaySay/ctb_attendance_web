import 'package:rxdart/rxdart.dart';

class UserModel{
  // CURRENT USERS
  BehaviorSubject<Map> loggedUser = new BehaviorSubject();
  Stream get streamLogged => loggedUser.stream;
  Map get valueLogged => loggedUser.value;

  updateUser({required Map data}){
    loggedUser.add(data);
  }
}
final UserModel userModel = new UserModel();
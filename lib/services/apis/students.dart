import 'package:firebase_database/firebase_database.dart';

class UsersApi{
  Future getUsers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
      ref.onValue.listen((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.exists) {
          final data = dataSnapshot.value;
          if (data is Map) {
            // usersModel.update(data: data.values.toList());
            print("USERS ${data.values.toList()}");
          } else if (data is List) {
            // usersModel.update(data: data);
          }
        } else {
          // usersModel.update(data: []);
        }
    });
  }
}


import 'package:firebase_database/firebase_database.dart';

class BorrowersApi{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future getBorrowers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('borrow');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          // borrowersModel.update(data: data.values.toList());
          print("BORROWERS ${data.values.toList()}");
        } else if (data is List) {
          // borrowersModel.update(data: data);
        }
      } else {
        // borrowersModel.update(data: []);
      }
    });
  }

  Future updateStatus({required String isbn, required String status})async{
    DatabaseReference usersRef = database.ref('borrow');
    FirebaseDatabase.instance.ref().child('borrow').orderByChild("isbn").equalTo(isbn).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/status": status,
      });
    });
  }
}


import 'package:firebase_database/firebase_database.dart';

class BooksApi{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future addBook({required Map payload})async{
    DatabaseReference usersRef = database.ref('books');
    await usersRef.push().set({
      "subject": payload["subject"],
      "title": payload["title"],
      "author": payload["author"],
      "publisher": payload["publisher"],
      "copyright": payload["copyright"],
      "edition_number": payload["edition_number"],
      "pages_number": payload["pages_number"],
      "isbn": payload["isbn"],
      "stock": payload["stock"],
      "shell_number": payload["shell_number"],
      "summary": payload["summary"],
      "categories": payload["categories"],
      "base64Image": payload["base64Image"],
    });
  }

  Future editBook({required String old_isbn,required Map payload})async{
    DatabaseReference usersRef = database.ref('books');
    FirebaseDatabase.instance.ref().child('books').orderByChild("isbn").equalTo(old_isbn).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/subject": payload["subject"],
        "${event.snapshot.key!}/title": payload["title"],
        "${event.snapshot.key!}/author": payload["author"],
        "${event.snapshot.key!}/publisher": payload["publisher"],
        "${event.snapshot.key!}/copyright": payload["copyright"],
        "${event.snapshot.key!}/edition_number": payload["edition_number"],
        "${event.snapshot.key!}/pages_number": payload["pages_number"],
        "${event.snapshot.key!}/isbn": payload["isbn"],
        "${event.snapshot.key!}/stock": payload["stock"],
        "${event.snapshot.key!}/shell_number": payload["shell_number"],
        "${event.snapshot.key!}/summary": payload["summary"],
        "${event.snapshot.key!}/categories": payload["categories"],
        "${event.snapshot.key!}/base64Image": payload["base64Image"],
      });
    });
  }

  Future deleteBook({required String isbn})async{
    FirebaseDatabase.instance.ref().child('books').orderByChild("isbn").equalTo(isbn).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("books/${event.snapshot.key!}");
      await ref.remove();
    });
  }

  Future getBooks() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('books');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          // booksModel.update(data: data.values.toList());
          // print("BOOKS ${data.values.toList()}");
        } else if (data is List) {
          // booksModel.update(data: data);
        }
      } else {
        // booksModel.update(data: []);
      }
    });
  }
}
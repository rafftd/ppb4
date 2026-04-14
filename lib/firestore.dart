import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService{

  CollectionReference<Map<String, dynamic>> get notes {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('User belum login');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes');
  }

  //create new note
  Future<void> addNote(String title, String content, String label) {
    return notes.add({
      'title': title,
      'content': content,
      'label': label,
      'tgl': Timestamp.now(),
    });
  }

  //fetch all notes
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotes() {
    return notes.orderBy('tgl', descending: true).snapshots();
  }

  //update notes
  Future<void> updateNote(String id, String title, String content, String label) {
    return notes.doc(id).update({
      'title': title,
      'content': content,
      'label': label,
    });
  }

  //delete notes
  Future<void> deleteNote(String id) {
    return notes.doc(id).delete();
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirestoreService {
  final userUID = FirebaseAuth.instance.currentUser!.uid;

  // get collection of notes from db
  final CollectionReference notes = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');

  // Create: add new note
  Future<void> addNote(String note) async {
    if (note.isEmpty) return;
    final data = {
    'note': note,
    'timestap': Timestamp.now()
    };
    await notes.doc().set(data);
  }
  
 
  // Read: get notes from db
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes.orderBy('timestap', descending: true).snapshots();

    return notesStream;
  }

  // Update: update notes in db given doc id
  Future<void> updateNote(String docID, String newNote) async {
    if (newNote.isEmpty) return;
    final data = {
      'note': newNote,
      'timestap': Timestamp.now()
    };
    await notes.doc(docID).update(data);
  }

  // Delete: delete notes from db given doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // User
  final user = FirebaseAuth.instance.currentUser!;

  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  // open dialog box to add note
  void openNoteBox({String? docID}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
        ),
        actions: [
          // button to save
          ElevatedButton(
            onPressed: () {
              // update or add new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              } else {
                firestoreService.updateNote(docID, textController.text);
              }
               
              // clear text field
              textController.clear();

              // close dialog boc
              Navigator.pop(context);
            }, 
            child: const Text('Add')
          )
        ]
        ),
      );
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
          ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            // if we have data, get all docs
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              // display as list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  // get doc
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  // get note in doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  // display as list tile
                  return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // update button
                        IconButton(
                      onPressed: () => openNoteBox(docID: docID), 
                      icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                      onPressed: () => firestoreService.deleteNote(docID), 
                      icon: const Icon(Icons.delete),
                      ),
                    ])
                  );
                },
              );
            } else {
              return const Text("No Notes...");
            }
          },
        ),
      );
    }
  }

  

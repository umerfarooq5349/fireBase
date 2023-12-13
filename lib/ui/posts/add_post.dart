import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addNoteController = TextEditingController();

  DatabaseReference dataRef = FirebaseDatabase.instance.ref();
  final dataBase = FirebaseDatabase.instance;
  String tableName = '';
  bool loading = false;

  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    tableName = '/$uid/Post';
    dataRef = dataBase.ref(tableName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Post',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                const SizedBox(
                  height: 90,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Write something here',
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        maxLines: 4,
                        controller: addNoteController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: "What's in your mind",
                          helperText: 'My self',
                          helperStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 16),
                          hintStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please add smething first!';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                    title: 'Add',
                    onTap: () {
                      setState(() {
                        loading = true;
                      });

                      String id =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      dataRef.child(id).set(
                        {
                          'id': id,
                          'description': addNoteController.text.toString(),
                        },
                      ).then(
                        (value) {
                          Utils().toastMessage('Added', Colors.green);
                          setState(() {
                            loading = false;
                            addNoteController.text = ' ';
                          });
                        },
                      ).onError(
                        (error, stackTrace) {
                          Utils().toastMessage(
                            error.toString(),
                            Colors.red,
                          );
                          setState(() {
                            loading = false;
                          });
                        },
                      );
                    },
                    loading: loading)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

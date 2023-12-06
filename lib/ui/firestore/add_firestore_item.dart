import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';

import 'package:flutter/material.dart';

class AddFirestoreItemScreen extends StatefulWidget {
  const AddFirestoreItemScreen({super.key});

  @override
  State<AddFirestoreItemScreen> createState() => _AddFirestoreItemScreenState();
}

class _AddFirestoreItemScreenState extends State<AddFirestoreItemScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addNoteController = TextEditingController();
  final userdata = FirebaseFirestore.instance.collection('Users');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Firestore Item',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                          helperText: 'My self is umer',
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

                      userdata.doc(id).set({
                        'description': addNoteController.text.toString(),
                        'id': id,
                      }).then((value) {
                        setState(() {
                          setState(() {
                            loading = false;
                          });
                        });
                        Utils().toastMessage('Added succesfully', Colors.green);
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(error.toString(), Colors.red);
                      });
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

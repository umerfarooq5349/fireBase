import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/ui/firestore/add_firestore_item.dart';

import 'package:firebase_app/utils/utils.dart';
// import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class FirestoreStore extends StatefulWidget {
  const FirestoreStore({super.key});

  @override
  State<FirestoreStore> createState() => _FirestoreStoreState();
}

class _FirestoreStoreState extends State<FirestoreStore> {
  final _auth = FirebaseAuth.instance;
  final userdata = FirebaseFirestore.instance.collection('Users').snapshots();
  final searchQuery = TextEditingController();
  final userDataCollec = FirebaseFirestore.instance.collection('Users');
  final updateText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Firestore Data List',
            style: TextStyle(
              color: Colors.white,
            )),
        actions: [
          IconButton(
              color: Colors.white,
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage('Log out error', Colors.red);
                });
              },
              icon: const Icon(
                Icons.logout,
                size: 28,
              ))
        ],
      ),
      body: Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: searchQuery,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.deepPurple,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.deepPurple,
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
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            StreamBuilder(
              stream: userdata,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.deepPurple,
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error in fetching data'),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final description = snapshot
                            .data!.docs[index]['description']
                            .toString();

                        if (searchQuery.text.isEmpty ||
                            description
                                .toLowerCase()
                                .contains(searchQuery.text.toLowerCase())) {
                          return ListTile(
                            title: Text(description),
                            trailing: PopupMenuButton(
                              color: Colors.white,
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text(
                                        'Edit',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      onTap: () {
                                        showMyDailogue(
                                            snapshot.data!
                                                .docs[index]['description']
                                                .toString(),
                                            snapshot.data!.docs[index]['id']
                                                .toString());
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text(
                                        'Delete',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      onTap: () {
                                        userDataCollec
                                            .doc(snapshot
                                                .data!.docs[index]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Navigator.pop(context);
                                          Utils().toastMessage(
                                              "Deleted", Colors.green);
                                        }).onError((error, stackTrace) {
                                          Navigator.pop(context);
                                          Utils().toastMessage(
                                              error.toString(), Colors.red);
                                        });
                                      },
                                    ),
                                  ),
                                ];
                              },
                              child: const Icon(Icons.more_vert),
                            ),
                          );
                        } else {
                          return Center(
                            child: Container(),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
            // RoundedButton(
            //     title: 'Add',
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const AddFirestoreItemScreen(),
            //           ));
            //     },
            //     loading: false)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFirestoreItemScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDailogue(String title, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        updateText.text = title;
        return AlertDialog(
          title: const Text('Update'),
          content: TextFormField(
            controller: updateText,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "Update",
              hintStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
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
                return 'Please update something first!';
              } else {
                return null;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                userDataCollec.doc(id).update(
                    {'description': updateText.text.toString()}).then((value) {
                  Navigator.pop(context);
                  Utils().toastMessage("Updated", Colors.green);
                }).onError((error, stackTrace) {
                  Navigator.pop(context);
                  Utils().toastMessage(error.toString(), Colors.red);
                });
              },
              child: const Text(
                'Update',
              ),
            ),
          ],
        );
      },
    );
  }
}

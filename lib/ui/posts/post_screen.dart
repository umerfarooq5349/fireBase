import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/ui/posts/add_post.dart';
import 'package:firebase_app/utils/utils.dart';
// import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  final dataRef = FirebaseDatabase.instance.ref('Post');
  final searchQuery = TextEditingController();

  final updateText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Post Screen',
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
      body: Column(
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
          Expanded(
            child: FirebaseAnimatedList(
              query: dataRef,
              defaultChild: const Text('Loading'),
              itemBuilder: (context, snapshot, animation, index) {
                final search = snapshot.value.toString();

                if (searchQuery.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('description').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDailogue(
                                  snapshot
                                      .child('description')
                                      .value
                                      .toString(),
                                  snapshot.child('id').value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              dataRef
                                  .child(snapshot.child('id').value.toString())
                                  .remove()
                                  .then((value) {})
                                  .onError((error, stackTrace) {
                                Utils()
                                    .toastMessage(error.toString(), Colors.red);
                              });
                            },
                            leading: const Icon(Icons.delete_outline),
                            title: const Text('Delete'),
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  );
                } else if (search
                    .toLowerCase()
                    .contains(searchQuery.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('description').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDailogue(
                                  snapshot
                                      .child('description')
                                      .value
                                      .toString(),
                                  snapshot.child('id').value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);

                              dataRef
                                  .child(snapshot.child('id').value.toString())
                                  .remove()
                                  .then((value) {})
                                  .onError((error, stackTrace) {
                                Utils()
                                    .toastMessage(error.toString(), Colors.red);
                              });
                            },
                            leading: const Icon(Icons.delete_outline),
                            title: const Text('Delete'),
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  );
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          ),
          //  RoundedButton(
          //     title: 'Add',
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const AddPostScreen(),
          //           ));
          //     },

          //     loading: false)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPostScreen(),
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
                dataRef.child(id).update(
                    {'description': updateText.text.toString()}).then((value) {
                  Utils().toastMessage('Updated', Colors.green);
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString(), Colors.red);
                });
                Navigator.pop(context);
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



    //  Expanded(
    //         child: StreamBuilder(
    //             builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
    //               if (!snapshot.hasData) {
    //                 return CircularProgressIndicator();
    //               } else {
    //                 Map<dynamic, dynamic> map =
    //                     snapshot.data!.snapshot.value as dynamic;
    //                 List<dynamic> fireDatabaseList = [];
    //                 fireDatabaseList.clear();
    //                 fireDatabaseList = map.values.toList();

    //                 return ListView.builder(
    //                   itemCount: snapshot.data?.snapshot.children.length,
    //                   itemBuilder: (context, index) {
    //                     return ListTile(
    //                       title: Text(
    //                         fireDatabaseList[index]['description'],
    //                       ),
    //                     );
    //                   },
    //                 );
    //               }
    //             },
    //             stream: dataRef.onValue),
    //       ),
    
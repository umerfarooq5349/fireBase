import 'dart:io';
import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  var imgURL;

  String refId = DateTime.now().microsecondsSinceEpoch.toString();
  // DatabaseReference uploadimg = FirebaseDatabase.instance.ref('Post');

  DatabaseReference uploadimg = FirebaseDatabase.instance.ref();
  final dataBase = FirebaseDatabase.instance;
  String tableName = '';
  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    tableName = '/$uid/Post';
    uploadimg = dataBase.ref(tableName);
    super.initState();
  }

  Future<void> getGalleryImage() async {
    setState(() {
      loading = true;
    });

    ImagePicker imgPicker = ImagePicker();
    XFile? file = await imgPicker.pickImage(source: ImageSource.gallery);
    print(file!.path);
    final fileExtension = p.extension(file.path);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImg = referenceRoot.child('images');
    Reference referenceOfImg = referenceDirImg
        .child("post${DateTime.now().millisecond}$fileExtension");

    try {
      await referenceOfImg.putFile(File(file.path));
      imgURL = await referenceOfImg.getDownloadURL(); // Remove toString()
      setState(() {
        loading = false;
        print('img $imgURL');
        Utils()
            .toastMessage("Image uploaded successfully $imgURL", Colors.green);
      });
    } catch (e) {
      Utils().toastMessage(e.toString(), Colors.red);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        title: const Text('Upload Image'),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  border: Border.all(
                    width: 2.5,
                    color: Colors.black,
                  )),
              child: imgURL != null
                  ? Image.network(imgURL.toString())
                  : const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 60,
                    ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundedButton(
              title: 'Upload Image',
              onTap: () async {
                getGalleryImage();
              },
              loading: loading)
        ],
      ),
    );
  }
}

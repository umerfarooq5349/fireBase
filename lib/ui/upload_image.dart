import 'dart:io';

import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;

  File? _image;
  final picker = ImagePicker();

  Future getGalleryImage() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      loading = true;
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        print("heelo this newpath " + _image!.path.toString());
        loading = false;
      } else {
        loading = false;
        Utils().toastMessage('Pick Image from gallery ', Colors.red);
        print("heelo" + _image!.path.toString());
      }
    });
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
              child: _image != null
                  ? Image.file(_image!.absolute)
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
              onTap: () {
                getGalleryImage();
              },
              loading: loading)
        ],
      ),
    );
  }
}

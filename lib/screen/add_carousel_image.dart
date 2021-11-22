import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi_tect_admin/constants/styles.dart';
import 'package:medi_tect_admin/widgets/custom_appbar.dart';
import 'package:medi_tect_admin/widgets/custom_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io';
import 'dart:io' as io;

class AddHomeCarouselScreen extends StatefulWidget {
  const AddHomeCarouselScreen({Key? key}) : super(key: key);

  @override
  State<AddHomeCarouselScreen> createState() => _AddHomeCarouselScreenState();
}

class _AddHomeCarouselScreenState extends State<AddHomeCarouselScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('carousel')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("Add Image"),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          SizedBox(
            height: 32.0,
          ),
          Center(
            child: Text(
              "Pick a Image",
              style: MyStyles.heading,
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: _imageFile != null
                ? Image.file(_imageFile!)
                : ElevatedButton(
                    child: Text("Select Image"),
                    onPressed: pickImage,
                  ),
          ),
          uploadImageButton(context),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.green],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Center(
              child: FlatButton(
                onPressed: () => uploadImageToFirebase(context),
                child: Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

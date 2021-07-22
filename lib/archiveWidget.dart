import 'dart:convert';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybabycheck_flutter/CustomTextField.dart';
import 'package:mybabycheck_flutter/RegistrationWidget.dart';
import 'package:mybabycheck_flutter/main.dart';
import 'package:mybabycheck_flutter/newsWidget.dart';
import 'package:mybabycheck_flutter/utils/auth.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';

class ArchiveWidget extends StatefulWidget {
  const ArchiveWidget({Key? key}) : super(key: key);
  @override
  _ArchiveWidgetState createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  PickedFile? _image = null;
  void setInvalidUserData(bool state) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> saveImageToSecStorage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    print(image!.path);
    bool flag = await SecurityStorage.storageContainsKey("archive");
    print("1");
    String value = "";
    if (flag) {
      value = await SecurityStorage.readFromStorage("archive");
      SecurityStorage.writeToStorage("archive", value + ";" + image.path);
    } else
      SecurityStorage.writeToStorage("archive", image.path);
  }

  Future<List<String>> getImages() async {
    String str = "";
    str = await SecurityStorage.readFromStorage("archive");
    print(str);
    return str.split(RegExp(";"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: saveImageToSecStorage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
        body: FutureBuilder(
          future: getImages(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>?> listImages) {
            if (listImages.hasData) {
              return ListView.builder(
                itemCount: listImages.data!.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Image.file(File(listImages.data![index])),
                  );
                },
              );
            } else {
              return SpinKitFadingCircle(
                color: Colors.cyan,
                size: 100.0,
              );
            }
          },
        ));
  }
}

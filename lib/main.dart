import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? newImage;
  XFile? image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imagePickerGallery();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            if(image != null)
              SizedBox(
                child: Image.file(
                    File(newImage!.path),
                    fit: BoxFit.fitHeight
                ),
              )
          ],
        ),
      ),
    );
  }


  Future imagePickerGallery() async {
    // final path_provider =
    image = (await picker.pickImage(source: ImageSource.gallery));
    final bytes = await image!.readAsBytes();


    final kb = bytes.length /1024;
    final mb = kb/1024;

    if(kDebugMode) {
    print("original image size : "+ mb.toString());
    }

    final dir = await getTemporaryDirectory();
  final targetPath = '${dir.absolute.path}/temp.jpg';


  final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
    minHeight: 300,
    quality: 80
    );

  final data = await result!.readAsBytes();

  final newKb = data.length / 1024;
  final newMb = newKb / 1024;

  if(kDebugMode) {
    print("compressedd image size : ${newMb.toString()}");
  }

  newImage = File(result.path);

  setState(() {});

  }
}
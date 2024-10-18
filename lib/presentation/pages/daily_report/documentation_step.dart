import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentationStep extends StatefulWidget {
  const DocumentationStep({Key? key}) : super(key: key);

  @override
  _DocumentationStepState createState() => _DocumentationStepState();
}

class _DocumentationStepState extends State<DocumentationStep> {
  List<String> imagePaths = []; // Initialize as an empty list

  // Function to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose an option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Camera"),
              onTap: () async {
                final image = await _picker.pickImage(source: ImageSource.camera);
                Navigator.of(context).pop(image);
              },
            ),
            ListTile(
              title: Text("Gallery"),
              onTap: () async {
                final image = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop(image);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path); // Add the image path to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PictureStacker(imagePaths: imagePaths),
        emptyCardPicture(onTap: _pickImage,),
        SizedBox(height: 20.0),
        IntrinsicHeight(
          child: TextField(
            maxLines: null,
            minLines: 1,
            decoration: InputDecoration(
              labelText: "Optional notes",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PictureStacker extends StatelessWidget {
  final List<String> imagePaths;

  PictureStacker({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: imagePaths.map((path) {
        return SizedBox(
          height: 300,
          width: 300,
          child: CardPicture(onTap: null, imagePath: path),
        );
      }).toList(),
    );
  }
}

class emptyCardPicture extends StatelessWidget {
  const emptyCardPicture({this.onTap});

  final Function()? onTap;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Card(
      color: Colors.white,
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
          width: size.width * .70,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attach Picture',
                style: TextStyle(fontSize: 17.0, color: Colors.grey[600]),
              ),
              Icon(
                Icons.photo_camera,
                color: Colors.indigo[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardPicture extends StatelessWidget {
  const CardPicture({this.onTap, this.imagePath});

  final Function()? onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (imagePath != null) {
      return Card(
        child: Container(
          height: 300,
          padding: EdgeInsets.all(10.0),
          width: size.width * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(File(imagePath!)),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    print('Delete icon pressed');
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Text("Error in CardPicture");

  }
}

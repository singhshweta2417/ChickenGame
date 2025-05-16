import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DirectGalleryPickerScreen extends StatefulWidget {
  @override
  _DirectGalleryPickerScreenState createState() => _DirectGalleryPickerScreenState();
}

class _DirectGalleryPickerScreenState extends State<DirectGalleryPickerScreen> {
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _selectedImages = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery Image Picker')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Select Images from Gallery'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _selectedImages.isEmpty
                ? Center(child: Text('No images selected'))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Image.file(
                  _selectedImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
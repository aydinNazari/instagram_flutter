import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    //return await File(_file.path);
    return await _file.readAsBytes();
  }
  print('no image selected');
}

showSnackBar(
    String contant, BuildContext context, Color colorBack, Color colorText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colorBack,
      content: Text(
        contant,
        style: TextStyle(
          color: colorText,
        ),
      ),
    ),
  );
}

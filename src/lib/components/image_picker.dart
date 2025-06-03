import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class ImagePicker{
  bool isPick = false;
  late Widget imageWidget;
  late ImageProvider imageProvider;
  late File file;
  pick() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']
    );
    if(result != null) {
      file = File(result.files.single.path.toString());
      isPick = true;
      imageProvider = FileImage(file.absolute);
      imageWidget = Image.file(file.absolute);
      return file;
    } else {
      isPick = false;
    }
  }
  toBased64()
  {
    List<Map> attach = [{
      'fileName': basename(file.path),
      'encoded': base64Encode(file.readAsBytesSync())
    }];
    return jsonEncode(attach);
  }
}
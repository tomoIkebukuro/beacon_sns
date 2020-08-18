import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//カメラで撮影した写真(File)を選択する
Future<File> pickFileFromCamera() async {

  //pickImageには例外処理が必要
  var pickedFile= await ImagePicker().getImage(source: ImageSource.camera);
  if(pickedFile==null){
    return null;
  }
  return File(pickedFile.path);
}

Future<File> pickFileFromGallery() async {

  //pickImageには例外処理が必要
  var pickedFile= await ImagePicker().getImage(source: ImageSource.gallery);
  if(pickedFile==null){
    return null;
  }
  return File(pickedFile.path);
}


Future<File> cropAvatar(File file) async{
  if(file==null){
    return null;
  }
  return await ImageCropper.cropImage(
    sourcePath: file.path,
    aspectRatio: CropAspectRatio(ratioX: 1,ratioY:1),
    cropStyle: CropStyle.circle,
    androidUiSettings: AndroidUiSettings(
      toolbarWidgetColor: Colors.green,
      hideBottomControls: true,
    ),
  );
}
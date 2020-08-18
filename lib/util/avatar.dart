import '../global_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';



class NetworkAvatar extends StatelessWidget{

  final String avatarUrl;
  final double size;

  NetworkAvatar({this.size,this.avatarUrl});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.size,
      width: this.size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: this.avatarUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class FileAvatar extends StatelessWidget{

  final File file;
  final double size;

  FileAvatar({this.size,this.file});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.size,
      width: this.size,
      child: ClipOval(
        child: Image.file(file),
      ),
    );
  }
}
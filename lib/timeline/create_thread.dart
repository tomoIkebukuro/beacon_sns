import 'package:beaconsns/function/location.dart';
import 'package:beaconsns/function/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../function/firebase.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import '../global_model.dart';
import 'package:geolocator/geolocator.dart' show Position;

import '../load/load.dart';
import '../class.dart';
import '../util/raised_button.dart';
import 'comment_tile.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CreateThreadPage extends StatefulWidget{

  CreateThreadPage({Key key}):super(key:key);

  @override
  CreateThreadState createState()=>CreateThreadState();
}

class CreateThreadState extends State<CreateThreadPage>{

  final formKey = GlobalKey<FormState>();
  String content;

  Future<Null> onWriteButtonPressed(BuildContext context) async{

    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: "waiting",
      progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(),
      ),
    );

    await pr.show();

    var profile=context.read<GlobalModel>().myProfile;

    formKey.currentState.save();

    Location location;

    try{
      location=await getCurrentLocation();
    }catch(e){
      showErrorDialog(context, e.toString());
    }

    try{
      await uploadThread(Thread(
        name: profile.name,
        avatarUrl: profile.avatarUrl,
        userId: profile.userId,
        content: content,
        latitude: location.latitude,
        longitude: location.longitude,
        buzz:0
      ));
    }catch(e){
      showErrorDialog(context, e.toString());
    }



    await pr.hide();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RaisedButtonModified(
            onPressed: ()=>onWriteButtonPressed(context),
            text: "投稿",
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'コメント',
          ),
          maxLength: 144,
          maxLines: 20,
          validator: (value){
            if(value.length==0){
              return 'コメントを入力してください。';
            }
            return null;
          },
          onSaved: (value){
            content=value;
          },
          autofocus: false,
        ),
      ),
    );
  }
}

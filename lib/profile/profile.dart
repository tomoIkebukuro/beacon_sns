import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../global_model.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import '../util/raised_button.dart';
import '../function/firebase.dart';
import '../favorite/favorite_button.dart';
import '../class.dart';
import '../favorite/favorite.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget{

  final String userId;

  ProfilePage(this.userId);

  Future<Null> onChangeButtonPressed(BuildContext context) async{

    var profile = Provider.of<GlobalModel>(context,listen: false).myProfile;

    // プロフィール作成画面へ移動
    await Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return EditProfilePage(profile: profile,);
        },
    ),);

    return null;
  }



  @override
  Widget build(BuildContext context) {
    bool isMyProfile=Provider.of<GlobalModel>(context,listen: false).myProfile.userId==this.userId;
    return FutureBuilder<Profile>(
      future:getProfile(userId),
      builder: (context,snapshot){
        if(snapshot.hasError||snapshot.connectionState==ConnectionState.none){
          Center(
            child: Text("エラー"),
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data==null){
          return Center(
            child: Text("プロフィールが存在しません。\n削除された可能性があります。"),
          );
        }
        return Center(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: isMyProfile
                    ?RaisedButtonModified(text: "変更", onPressed: ()=>onChangeButtonPressed(context),)
                    :FavoriteButton(this.userId),
              ),
              Container(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data.avatarUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Text(snapshot.data.name),
              Text(snapshot.data.introduction),
            ],
          ),
        );
      },
    );
  }
}

class MyProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ProfilePage(context.watch<GlobalModel>().myProfile.userId);
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import '../global_model.dart';
import '../timeline/thread_tile.dart';
import '../load/load.dart';
import '../profile/edit_profile.dart';
import '../class.dart';
import '../timeline/comment_tile.dart';


class Favorite extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    List<String> favoriteList=context.select<GlobalModel,List<String>>((model)=>model.favoriteMap.keys.toList());

    if(favoriteList.length==0){
      return Center(
        child: Text("お気に入り登録されたユーザがまだ存在しません。"),
      );
    }
    print(favoriteList);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("thread").where("userId",whereIn: favoriteList).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError || snapshot.connectionState==ConnectionState.none){
          return Center(child: Text("error"),);
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return ThreadTile(
              Thread.data(snapshot.data.documents[index].data),
            );
          },
        );
      },
    );
  }
}
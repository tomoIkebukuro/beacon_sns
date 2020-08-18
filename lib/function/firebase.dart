import 'package:beaconsns/function/geohash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../global_model.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../function/geohash.dart';
import "dart:math";

import '../class.dart';

CollectionReference _threadCollection=Firestore.instance.collection('thread');

Future<String> uploadImage({File file,String collectionName,String fileName}) async {
  final StorageReference ref = FirebaseStorage.instance.ref().child(collectionName).child(fileName);
  final StorageUploadTask uploadTask = ref.putFile(file);
  StorageTaskSnapshot snapshot = await uploadTask.onComplete;
  return await snapshot.ref.getDownloadURL();
}

Future<Null> uploadProfile(BuildContext context,Profile profile,File nextAvatar) async {

  if (nextAvatar != null) {
    profile.avatarUrl = await uploadImage(
        file: nextAvatar,
        collectionName: 'images',
        fileName: "dummy"
    );
  }
  await Firestore.instance.collection('profile').document(profile.userId).setData(profile.toData());

  return null;

}

Future<Null> updateMyProfile(BuildContext context,Profile profile,File avatar)async{
  await uploadProfile(context, profile, avatar);
  context.read<GlobalModel>().myProfile=profile;
  return null;
}

Future<Profile> resetMyProfile(BuildContext context,String id)async{
  var initialProfile=Profile.getInitialProfile(id);
  await updateMyProfile(context, initialProfile, null);
  return initialProfile;
}



// サーバの状態を取得する関数
//　そもそもサーバに接続できなければnullを返す
Future<Map<String,String>> getServerState()async{
  var stateDocument=await Firestore.instance.collection('talks').document('document-name').get();
  if(stateDocument == null){
    throw Exception("getServerState:サーバに接続できません。\nネットワークの接続を確認してください。");
  }
  if(stateDocument.exists==false){
    throw Exception("getServerState:サーバのstateを確認できません。");
  }
  return stateDocument.data;
}

//プロフィールを取得
Future<Profile> getProfile(String uid)async{
  DocumentSnapshot snapshot;

  snapshot=await Firestore.instance.collection('profile').document(uid).get();

  if(snapshot == null || snapshot.exists==false){
    return null;
  }
  return Profile(snapshot.data);
}

Future<Null> deleteProfile(BuildContext context,String uid) async{
  await Firestore.instance.collection('profile').document(uid).delete();

  return null;
}

Future<Null> uploadThread(Thread thread) async{
  var latitude=thread.latitude;
  var longitude=thread.longitude;
  Map<String,dynamic> data=thread.toData();
  for(int i=10;i<=15;i+=1){
    data["geoSection_$i"]=GeoSection(latitude:latitude,longitude:longitude,zoomLevel: i).toString();
  }
  await _threadCollection.document().setData(data);
}

Future<FirebaseUser> loadUser()async{
  return await FirebaseAuth.instance.currentUser();
}

Query geoQueryThread({@required double latitude, @required double longitude,@required int zoomLevel}){
  var section=GeoSection(latitude:latitude,longitude:longitude,zoomLevel: zoomLevel);
  var neighbors=section.getNeighbors();
  var neighborsSection=[section.toString()];
  neighbors.forEach((element) {
    neighborsSection.add(element.toString());
  });
  print(neighborsSection);
  return _threadCollection.where("geoSection_$zoomLevel",whereIn: neighborsSection);
}

/*
Query geoQueryThread({@required double latitude, @required double longitude,@required double km,@required length}){
  double earthRadius=6371.0;
  var i =km*180/(earthRadius*pi);
  var j =km*180/(earthRadius*cos(latitude*pi/180)*pi);
  if(180<j)j=180;
  double fromLatitude=latitude-i;
  double toLatitude=latitude+i;
  double fromLongitude=longitude-j;
  double toLongitude=longitude+j;

  if(fromLatitude<-90)fromLatitude=-90;
  if(90<toLatitude)toLatitude=90;

  if(fromLongitude<-180){
    print("beyond the bound");
    double _fromLongitude=180-(-180-fromLongitude);
    fromLongitude=_fromLongitude;
  }

  if(180<toLongitude){
    print("beyond the bound");
    double _toLongitude=-180+(toLongitude-180);
    toLongitude=_toLongitude;
  }


  var a=_threadCollection
      .where("latitude",isGreaterThan: fromLatitude)
      .where("latitude",isLessThan: toLatitude);
  return
      a;
}
*/



var _testCollection = Firestore.instance.collection('test');

Future<Null> testUpload()async{

  Map<String,dynamic> data={};
  for(int i =0;i<10;i+=1){
    data[i.toString()]=0;
  }
  _testCollection.document().setData(data);
}

Query testQuery(){

  Query query=_testCollection;

  for(int i=0;i<10;i+=1){
    query=query.where(i.toString(),isEqualTo: 0);
  }

  return query;
}
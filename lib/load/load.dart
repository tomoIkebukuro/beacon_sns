import 'package:beaconsns/navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart' show Position;
import '../global_model.dart';
import 'login.dart';
import '../profile/edit_profile.dart';
import '../function/util.dart';
import '../function/firebase.dart';
import '../function/location.dart';
import '../test.dart';
import '../class.dart';
import '../map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/scheduler.dart';

class LoadPage extends StatefulWidget{
  @override
  State<LoadPage> createState()=>LoadState();
}

class LoadState extends State<LoadPage>{

  Future<FirebaseUser> loadUser(BuildContext context) async{
    while(true){
      FirebaseUser user;
      try{
        user = await FirebaseAuth.instance.currentUser();
      }catch(e){
        await showErrorDialog(context,"ユーザの取得に失敗しました。\n${e.toString()}");
        continue;
      }
      if(user!=null){
        return user;
      }
      else{
        // ユーザが登録されていない
        // ログイン画面へ移動
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }
    }
  }

  Future<Profile> loadProfile(BuildContext context,String userId)async{
    while(true){
      try{
        Profile profile=await getProfile(userId);
        if(profile==null){
          // プロフィールがそもそも存在しないのでプロフィールを初期化
          //　初期化したプロフィールをprofileに代入

          Profile initialProfile=Profile.getInitialProfile(userId);

          await uploadProfile(context, initialProfile, null);

          // プロフィール作成画面へ移動
          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => EditProfilePage(profile: initialProfile,),
          ));
        }
        else{
          return profile;
        }
      }catch(e){
        await showErrorDialog(context, "プロフィールの取得に失敗しました。\nネットワークの接続を確認してください。");
        continue;
      }
    }
  }

  Future<Location> loadLocation(BuildContext context)async{
    while(true){
      bool permissionAllowed=await checkLocationPermission();
      if(permissionAllowed){
        return await getCurrentLocation();
        return null;
      }
      bool requestSucceed=await requestLocationPermission();
      if(requestSucceed){
        return await getCurrentLocation();
      }
      await openAppSettings();
    }
  }

  Future<Null> load(BuildContext context)async{

    var model=Provider.of<GlobalModel>(context,listen: false);

    var user=await loadUser(context);

    model.user=user;

    var profile=await loadProfile(context,user.uid);

    model.myProfile=profile;

    var location =await loadLocation(context);

    model.updateLocation(location);


    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => NavigationPage(),
      ));
    });
    return null;

  }

  @override
  void initState() {
    // Call your async method here
    load(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
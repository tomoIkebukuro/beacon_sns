import 'dart:io';

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
import '../function/util.dart';
import '../class.dart';
import '../function/firebase.dart';
import '../util/raised_button.dart';
import '../util/avatar.dart';
import '../function/image.dart';



class EditProfilePage extends StatefulWidget{

  final Profile profile;

  EditProfilePage({Key key,@required this.profile}):super(key:key);

  @override
  EditProfileState createState()=>EditProfileState();
}

class EditProfileState extends State<EditProfilePage>{

  final formKey = GlobalKey<FormState>();
  //Profile profile;

  Future<Null> onCameraButtonPressed(BuildContext context)async{
    try{
      context.read<AvatarModel>().nextAvatar=await cropAvatar(await pickFileFromCamera());
    }catch(e){
      showErrorDialog(context, e.toString());
    }
    Navigator.of(context).pop();
    return null;
  }

  Future<Null> onGalleryButtonPressed(BuildContext context)async{
    try{
      context.read<AvatarModel>().nextAvatar=await cropAvatar(await pickFileFromGallery());
    }catch(e){
      showErrorDialog(context, e.toString());
    }
    return null;
  }

  Future<Null> onSaveButtonPressed(BuildContext context) async{

    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: "waiting",
      progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(),
      ),
    );
    await pr.show();

    //formの内容をチェック
    if(!formKey.currentState.validate()) {
      return null;
    }

    formKey.currentState.save();

    var avatar=context.read<AvatarModel>().nextAvatar;

    try{
      await updateMyProfile(context, widget.profile,avatar );
    }catch(e){
    showErrorDialog(context, "");
    return null;
    }

    await pr.hide();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //profile??=widget.profile;
    return ChangeNotifierProvider(
      create: (context)=>AvatarModel(),
      builder: (context,child){

        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              RaisedButtonModified(
                onPressed: ()=>onSaveButtonPressed(context),
                text: "保存",
              )
            ],
          ),
          body: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  reverse: false,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:<Widget>[
                      Consumer<AvatarModel>(
                        builder: (context,model,child){
                          File file=model.nextAvatar;
                          if(file==null){
                            return NetworkAvatar(
                              avatarUrl:widget.profile.avatarUrl,
                              size: 100,
                            );
                          }
                          return FileAvatar(
                            file: file,
                            size: 100,
                          );
                        },
                      ),
                      GestureDetector(
                        child: Text("プロフィール写真を変更",style: TextStyle(color: Colors.blue),),
                        onTap: (){
                          showDialog(
                            context: context,
                              builder: (_){
                                return SimpleDialog(
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      child: Text("写真を撮る"),
                                      onPressed: (){
                                        onCameraButtonPressed(context);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Text("写真を選ぶ"),
                                      onPressed: (){
                                        onGalleryButtonPressed(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '名前　',
                              ),
                              maxLength: 32,
                              //controller: nameController,
                              initialValue: widget.profile.name,
                              validator: (value){
                                if(value.length==0){
                                  return '名前を入力してください。';
                                }
                                return null;
                              },
                              onSaved: (value){
                                widget.profile.name=value;
                              },
                              autofocus: false,
                            ),
                            TextFormField(
                              initialValue: widget.profile.introduction,
                              keyboardType: TextInputType.multiline,
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: '紹介文',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 20,
                              maxLength: 256,
                              validator: (value){
                                if(value.length==0){return '紹介文を入力してください。';}
                                return null;
                              },
                              onSaved: (value){
                                widget.profile.introduction=value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );


  }
}
class AvatarModel with ChangeNotifier{

  AvatarModel();

  //nextAvatarは次に設定するアバター
  //新しく写真を撮るなどしてアバターを変更すると代入される
  //nullの場合はアバターが変更されていないことを示す
  File _nextAvatar;
  get nextAvatar => _nextAvatar;
  set nextAvatar(value){
    _nextAvatar=value;
    notifyListeners();
  }

}
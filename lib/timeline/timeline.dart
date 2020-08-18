import 'package:beaconsns/util/raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../global_model.dart';
import '../class.dart';
import 'comment_tile.dart';
import 'create_thread.dart';
import 'thread_tile.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../function/firebase.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Timeline extends StatelessWidget{

  Future<Null> onChangeButtonPressed(BuildContext context)async{
    showMaterialNumberPicker(
      context: context,
      title: "Pick Your Age",
      maxNumber: 100,
      minNumber: 0,
      selectedNumber: 1,
      onChanged: (value) async{
        Provider.of<GlobalModel>(context,listen: false).zoomLevel=value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var location=context.select<GlobalModel,Location>((model)=>model.location);
    //var distance=context.select<GlobalModel,int>((model)=>model.distance);
    return Scaffold(
      appBar: AppBar(
        title: Text("sss"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: geoQueryThread(
          latitude: location.latitude,
          longitude: location.longitude,
          zoomLevel: 10
        ).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError || snapshot.connectionState==ConnectionState.none){
            return Center(child: Text("error"),);
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length+2,
            itemBuilder: (context,index){
              if(index==0){
                return Container(
                  height: 50,
                  margin: EdgeInsets.all(30),
                  child:RaisedButton(
                    shape: StadiumBorder(),
                    child: Icon(Icons.add),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CreateThreadPage(),
                      ));
                    },
                  ),
                );
              }
              if(index==1){
                return Container(
                  child: Row(
                    children: <Widget>[
                      Text("周辺 ${Provider.of<GlobalModel>(context,listen: false).zoomLevel}を探索中..."),
                      RaisedButtonModified(
                        text: "変更",
                        onPressed: ()=>onChangeButtonPressed(context),
                      ),
                    ],
                  ),
                );
              }
              return ThreadTile(
                Thread.data(snapshot.data.documents[index-2].data),
              );
            },
          );
        },
      ),
    );
  }
}

class TimelineModel with ChangeNotifier{
  int _count;
  get count=>_count;
  set count(value){
    _count=value;
    notifyListeners();
  }

  TimelineModel(){
    count=1;
  }
}



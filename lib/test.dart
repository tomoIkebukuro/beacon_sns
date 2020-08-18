import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'global_model.dart';

import 'load/load.dart';
import 'profile/edit_profile.dart';
import 'package:geolocator/geolocator.dart';
import 'function/firebase.dart';
import 'dart:math';

class TestPage extends StatelessWidget{

  void f()async{
    await testUpload();
  }

  @override
  Widget build(BuildContext context) {
    f();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: testQuery().snapshots(),
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
                return ListTile(
                  title: Text(index.toString()),
                );
              }
          );
        },
      ),
    );
  }
}

/*
import 'dart:math';

const Map<String, String> _base32 = const <String, String>{
    '0':'0',
    '1':'1',
    '2':'2',
    '3':'3',
    '4':'4',
    '5':'5',
    '6':'6',
    '7':'7',
    '8':'8',
    '9':'9',
    'a':'b',
    'b':'c',
    'c':'d',
    'd':'e',
    'e':'f',
    'f':'g',
    'g':'h',
    'h':'j',
    'i':'k',
    'j':'m',
    'k':'n',
    'l':'p',
    'm':'q',
    'n':'r',
    'o':'s',
    'p':'t',
    'q':'u',
    'r':'v',
    's':'w',
    't':'x',
    'u':'y',
    'v':'z'
  };

void main() {
  var lat=35.634753;
  var lon=139.719384;
  final latHex = (lat + 90) * (pow(2, 20) / 180);
  final lonHex = (lon + 180) * (pow(2, 20) / 360);
  var la=latHex.floor().toRadixString(2).split("");
  var lo=lonHex.floor().toRadixString(2).split("");
  var hash=[];

  for(int i=0;i<min(la.length,lo.length);i+=1){
    hash.add(lo[i]);
    hash.add(la[i]);
  }

  print(hash);
  int a=0;
  var _hash=hash.reversed.toList();
  for(int i=0;i<_hash.length;i+=1){
    if(_hash[i]=='1'){
      a+=pow(2,i);
    }
  }
  var b=a.toRadixString(32).split("");
  var c=[];
  b.forEach((e){
    c.add(_base32[e]);
  });
  print(c.join(""));
}

 */



const Map<String, String> _base32 = const <String, String>{
  '0':'0',
  '1':'1',
  '2':'2',
  '3':'3',
  '4':'4',
  '5':'5',
  '6':'6',
  '7':'7',
  '8':'8',
  '9':'9',
  'a':'b',
  'b':'c',
  'c':'d',
  'd':'e',
  'e':'f',
  'f':'g',
  'g':'h',
  'h':'j',
  'i':'k',
  'j':'m',
  'k':'n',
  'l':'p',
  'm':'q',
  'n':'r',
  'o':'s',
  'p':'t',
  'q':'u',
  'r':'v',
  's':'w',
  't':'x',
  'u':'y',
  'v':'z'
};

class GeoBinary{

  List<String> latitudeBinary;
  List<String> longitudeBinary;
  static const int latitudeBinaryDigit=31;
  static const int longitudeBinaryDigit=32;
  static const int latitudeSup=1<<GeoBinary.latitudeBinaryDigit;
  static const int longitudeSup=1<<GeoBinary.longitudeBinaryDigit;

  int longitudeInt;
  int latitudeInt;

  GeoBinary(double latitude,double longitude){

    if(longitudeBinaryDigit-latitudeBinaryDigit!=1){
      throw Exception("exception in binary digit");
    }

    if((latitude<-90) || (90<latitude)){
      throw Exception("latitude exception");
    }

    if((longitude<-180) || (180<longitude)){
      throw Exception("longitude exception");
    }


    latitudeInt=((latitude + 90) * GeoBinary.latitudeSup / 180).floor();
    if(latitudeInt>=GeoBinary.latitudeSup){
      latitudeInt=0;
    }

    longitudeInt=((longitude + 180) * GeoBinary.longitudeSup / 360).floor();
    if(longitudeInt>=GeoBinary.longitudeSup){
      longitudeInt=0;
    }

  }

  String getGeoHash(){

    latitudeBinary=latitudeInt.toRadixString(2).padLeft(GeoBinary.latitudeBinaryDigit,'0').split("");

    longitudeBinary=longitudeInt.toRadixString(2).padLeft(GeoBinary.longitudeBinaryDigit,'0').split("");

    var geoBinary=longitudeBinary.sublist(0,1);

    longitudeBinary=longitudeBinary.sublist(1);

    if(longitudeBinary.length!=latitudeBinary.length){
      throw Exception("AAAAA");
    }

    for(int i=0;i<latitudeBinary.length;i+=1){
      geoBinary.add(latitudeBinary[i]);
      geoBinary.add(longitudeBinary[i]);
    }

    var end=(geoBinary.length/4).floor() * 4;

    var hash=geoBinary.sublist(0,end);

    var geoHexList = GeoBinary.bitToInt(hash).toRadixString(32).split("");

    var geoHashList=[];

    geoHexList.forEach((e){
      geoHashList.add(_base32[e]);
    });

    return geoHashList.join("");
  }

  static int bitToInt(bitList){
    int output=0;
    var lst=bitList.reversed.toList();
    for(int i=0;i<lst.length;i+=1){
      if(lst[i]=='1'){
        output+=1<<i;
      }
    }
    return output;
  }
}

void main(){
  var g=GeoBinary(48.669,-4.329);
  print(g.getGeoHash());
}

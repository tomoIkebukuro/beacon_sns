import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';

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


class GeoSection{

  int latitudeAddress;
  int longitudeAddress;
  int latitudeAddressSup;
  int longitudeAddressSup;
  int zoomLevel;

  GeoSection({@required double latitude,@required longitude,@required this.zoomLevel}){

    if(zoomLevel<0){
      throw Exception("exception in zoomLevel");
    }

    latitudeAddressSup=1<<zoomLevel;

    longitudeAddressSup=1<<(zoomLevel+1);

    if((latitude<-90) || (90<latitude)){
      throw Exception("latitude exception");
    }

    if((longitude<-180) || (180<longitude)){
      throw Exception("longitude exception");
    }

    latitudeAddress=((latitude + 90) * latitudeAddressSup/ 180).floor();
    if(latitudeAddress>=latitudeAddressSup){
      latitudeAddress=0;
    }

    longitudeAddress=((longitude + 180) * longitudeAddressSup / 360).floor();
    if(longitudeAddress>=longitudeAddressSup){
      longitudeAddress=0;
    }
  }

  GeoSection.address(this.latitudeAddress,this.longitudeAddress,this.zoomLevel){
    if(zoomLevel<0){
      throw Exception("exception in zoomLevel");
    }
    this.zoomLevel=zoomLevel;
    latitudeAddressSup=1<<zoomLevel;

    longitudeAddressSup=1<<(zoomLevel+1);
  }

  GeoSection.string(String sectionString,int zoomLevel){
    List<String> lst=sectionString.split(",");
    int latitudeAddress=int.parse(lst[0]);
    int longitudeAddress=int.parse(lst[1]);
    GeoSection.address(latitudeAddress,longitudeAddress,zoomLevel);
  }

  String toString(){
    return "${this.latitudeAddress},${this.longitudeAddress}";
  }

  List<double> toLatLng(){
    var a=-90+(180*this.latitudeAddress/this.latitudeAddressSup);
    var b=-180+(360*this.longitudeAddress/this.longitudeAddressSup);
    return [a,b];
  }

  List<GeoSection> getNeighbors(){

    var westLon=(this.longitudeAddress-1)%this.longitudeAddressSup;
    var eastLon=(this.longitudeAddress+1)%this.longitudeAddressSup;

    List<GeoSection> neighbors=[
      GeoSection.address(latitudeAddress, westLon, zoomLevel),
      GeoSection.address(latitudeAddress, eastLon, zoomLevel)
    ];

    var northLat=this.latitudeAddress+1;

    if(!(northLat==this.latitudeAddressSup)){
      neighbors.add(GeoSection.address(northLat, this.longitudeAddress, this.zoomLevel));
      neighbors.add(GeoSection.address(northLat, westLon, this.zoomLevel));
      neighbors.add(GeoSection.address(northLat, eastLon, this.zoomLevel));
    }

    var southLat=this.latitudeAddress-1;
    if(!(southLat==-1)){
      neighbors.add(GeoSection.address(southLat, this.longitudeAddress, this.zoomLevel));
      neighbors.add(GeoSection.address(southLat, westLon, this.zoomLevel));
      neighbors.add(GeoSection.address(southLat, eastLon, this.zoomLevel));
    }

    return neighbors;
  }

  String getGeoHash(){

    var latitudeBinary=latitudeAddress.toRadixString(2).padLeft(zoomLevel,'0').split("");

    var longitudeBinary=longitudeAddress.toRadixString(2).padLeft(zoomLevel+1,'0').split("");

    var geoBinary=longitudeBinary.sublist(0,1);

    longitudeBinary=longitudeBinary.sublist(1);

    if(longitudeBinary.length!=latitudeBinary.length){
      throw Exception("AAAAA");
    }

    for(int i=0;i<latitudeBinary.length;i+=1){
      geoBinary.add(latitudeBinary[i]);
      geoBinary.add(longitudeBinary[i]);
    }


    var end=(geoBinary.length/5).floor() * 5;

    var hash=geoBinary.sublist(0,end);

    var geoHexList = GeoSection.bitToInt(hash).toRadixString(32).split("");


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
        output+=pow(2,i);
      }
    }
    return output;
  }

}
/*

void main(){
  var g=GeoSection(48.669,-4.329,10);
  print(g.getGeoHash());
  var e=g.getNeighbors();
  e.forEach((e){
    print(e.getGeoHash());
  });
}
*/


/*
class GeoHash{
  GeoHash.binary(List<String> latitudeBinary,List<String> longitudeBinary){

  }
}
*/
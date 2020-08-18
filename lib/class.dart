import 'package:flutter/foundation.dart';

class Profile{
  String name;
  String introduction;
  String userId;
  List<String> threads;
  String avatarUrl;

  Profile(data){
    name=data["name"];
    introduction=data["introduction"];
    userId=data["id"];
    threads=data["threads"].split(" ");
    avatarUrl=data["avatarUrl"];
  }

  Map<String,dynamic> toData(){
    Map<String,dynamic> data={};
    data["name"]=this.name;
    data["introduction"]=this.introduction;
    data["id"]=this.userId;
    data["threads"]=this.threads.join(" ");
    data["avatarUrl"]=this.avatarUrl;
    return data;
  }

  static Profile getInitialProfile(String userId){
    return Profile({
      "name":"",
      "introduction":"",
      "id":userId,
      "threads":"",
      "avatarUrl":"https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png",

    });
  }

  Profile clone(){
    return Profile(this.toData());

  }
}


class Thread{

  String name;
  String userId;
  String avatarUrl;
  String content;
  double latitude;
  double longitude;
  int buzz;

  Thread({
    @required this.userId,
    @required this.avatarUrl,
    @required this.name,
    @required this.content,
    @required this.latitude,
    @required this.longitude,
    @required this.buzz
    });

  Thread.data(Map<String,dynamic> data){
    this.name=data["name"];
    this.userId=data["userId"];
    this.avatarUrl=data["avatarUrl"];
    this.content=data["content"];
    this.latitude=data["latitude"];
    this.longitude=data["longitude"];
    this.buzz=data["buzz"];
  }

  Map<String,dynamic> toData(){

    Map<String,dynamic> data={};

    data["name"]=this.name;
    data["userId"]=this.userId;
    data["avatarUrl"]=this.avatarUrl;
    data["content"]=this.content;
    data["latitude"]=this.latitude;
    data["longitude"]=this.longitude;
    data["buzz"]=this.buzz;

    return data;
  }

  Thread clone(){
    return Thread.data(this.toData());
  }

}

class Comment{

  String name;
  String userId;
  String avatarUrl;


  String content;
  Comment({
    @required this.userId,
    @required this.avatarUrl,
    @required this.name,
    @required this.content,
  });

  Comment.data(Map<String,dynamic> data){

    this.name=data["name"];
    this.userId=data["userId"];
    this.avatarUrl=data["avatarUrl"];

    this.content=data["content"];
  }

  Map<String,dynamic> toData(){

    Map<String,dynamic> data={};


    data["name"]=this.name;
    data["userId"]=this.userId;
    data["avatarUrl"]=this.avatarUrl;

    data["content"]=this.content;

    return data;
  }

  Comment clone(){
    return Comment.data(this.toData());
  }

}


class Location{
  double latitude;
  double longitude;
  Location({this.latitude,this.longitude});
}

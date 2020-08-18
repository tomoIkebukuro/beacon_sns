import '../global_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';



class RaisedButtonModified extends StatelessWidget{

  final Function onPressed;
  final String text;


  RaisedButtonModified({this.onPressed,this.text});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>RaisedButtonModifiedModel(),
      builder: (context,child){
        return Container(
          margin: EdgeInsets.all(10),
          //width: 60,
          child: RaisedButton(
            child: Text(text,style: TextStyle(fontWeight: FontWeight.bold),),
            textColor: Colors.white,
            padding: EdgeInsets.all(3),
            shape: StadiumBorder(),
            onPressed: context.watch<RaisedButtonModifiedModel>().disabled ? null :() async {
              context.read<RaisedButtonModifiedModel>().disabled=true;
              await onPressed();
              context.read<RaisedButtonModifiedModel>().disabled=false;
            },
          ),
        );
      },
    );
  }
}

class RaisedButtonModifiedModel with ChangeNotifier{
  bool _disabled=false;
  get disabled => _disabled;
  set disabled(value){
    _disabled=value;
    notifyListeners();
  }
}

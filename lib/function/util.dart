import 'package:flutter/material.dart';

Future<Null> showErrorDialog(BuildContext context,String message)async{
  await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("エラーが発生しました。"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
  );
  return null;
}

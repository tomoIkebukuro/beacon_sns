import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import '../global_model.dart';

import '../load/load.dart';
import '../class.dart';
import '../favorite/favorite_button.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ThreadTile extends StatelessWidget{



  ThreadTile(this.thread);
  final Thread thread;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: thread.avatarUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()),);
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(thread.name,),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: thread.latitude.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                    text: "+1000000%",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FavoriteButton(thread.userId),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: (){

                    },
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Icon(Icons.trending_up,color: Colors.red,size: 60,),
                SizedBox(width: 5,),
                Text("FGHJKL+")
              ],
            ),
            Container(
              child: Text(
                thread.content,
                style:TextStyle(height:2),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
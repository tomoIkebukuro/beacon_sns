import '../global_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class FavoriteButton extends StatelessWidget{

  final String userId;

  FavoriteButton(this.userId);

  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel,Object>(
      selector: (context,model)=>model.favoriteMap[userId],
      builder: (context,isChoosed,child){
        if(isChoosed==true){
          return IconButton(
            icon: Icon(Icons.favorite,color: Colors.red,),
            onPressed: (){
              Provider.of<GlobalModel>(context,listen: false).deleteFavorite(userId);
            },
          );
        }
        else{
          return IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: (){
              Provider.of<GlobalModel>(context,listen: false).addFavorite(userId);
            },
          );
        }
      },
    );
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import '../theme-data.dart';
import '../scoped-models/main.dart';


class MemberItem extends StatelessWidget {
  final dynamic member;
  dynamic isPlaying;
  int index;
  final MainModel model;
  MemberItem(this.member, this.index, this.model);
  final MainModel _model = MainModel();


  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/buzzmee2.jpg')
        
        ),
          title: Text('${member.username}',
          style: KontactTheme.titleDarkBg
        ),
          subtitle: Text('${member.phone}',
          style: KontactTheme.subtitleDarkBg
        ),
        onTap: () {
        },
      );
    }); 
  
  }
}
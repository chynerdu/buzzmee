import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../theme-data.dart';

class SideDrawer extends StatelessWidget {
   final MainModel model;
   SideDrawer(this.model);
   Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // padding: EdgeInsets.only(left:0), 
        decoration: BoxDecoration(
          color: Color(0xff0d0d0d),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: new DecorationImage(
                  colorFilter:
                    ColorFilter.mode(Theme.of(context).buttonColor.withOpacity(0.2), BlendMode.darken),
                  fit: BoxFit.cover,
                  image: new ExactAssetImage("assets/buzzmee.jpg")
                )
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  Text('BuzzMee', 
                  style: KontactTheme.display1
                  ),
                  SizedBox(height: 10.0),
                  Text('Hello, ${model.authenticatedUser.username}',
                    style: KontactTheme.caption
                    ),
                ],)
              
            ),
            Container(
            child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                    Container(
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.music_note, size:18, color:Colors.white),
                        title: Text('Profile',
                         style: KontactTheme.titleDarkBg),
                        onTap: () {
                          
                        },
                      ),
                    ),
                    Divider(),
                  
                  ]  // LogoutListTile()
              ),
            ]
            )
            )
          ],
        ),
      )
    );
  }
}
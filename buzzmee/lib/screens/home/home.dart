import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
import '../../theme-data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/html.dart';
// import 'package:web_socket_channel/io.dart';
/// import 'package:adonis_websok/html.dart';
// import 'package:adonis_websok/io.dart';

// widget
import '../../widgets/member-item.dart';
import '../../widgets/side-drawer.dart';
// import '../screens/current-track.dart';
// import '../widgets/avatar-image-provider.dart';
// import '../widgets/playlist.dart';
// import '../widgets/album.dart';
// import '../widgets/search-input.dart';

class Home extends StatefulWidget {
  final MainModel model;
  Home(this.model);
  @override
    State<StatefulWidget> createState() {
    return _HomeState();
  }
  // _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  // search
  ScrollController scrollController;
  TextEditingController controller = new TextEditingController();
  String filter;
  TabController tabController;
  Function bodyTheming = flexPlayThemeDarkBoxDecoration;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final MainModel _model = MainModel();
  int _currentIndex = 0;
 
  dynamic bottomAppBarColor = Color(0xff0f0f0f);


  @override
  void initState() {
    // initNotification();
    // displayNotification();
    // adonisWebsocketConnection();
    // widget.model.initSocketConnection();
    widget.model.defaultWebSocket();
    widget.model.getMembers('allMembers');
    widget.model.getMembers('onlineMembers');
    super.initState();
    tabController = new TabController(vsync: this, length: 3);

  // buildMedia(model) {
  //   return  model.currentStatus == 'fetched' ? projectWidget(model) : 
  //   Column(
  //     mainAxisSize: MainAxisSize.max,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     // crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //     Center(
  //       child: Container(
  //           padding: EdgeInsets.only(top:200),
  //           child:CircularProgressIndicator(backgroundColor: Color(0xffffa500))
  //           )      
  //     ),
  //     Center(
  //       child: Container(
  //           padding: EdgeInsets.only(top:20),
  //           child:Text('Loading songs',
  //           style: KontactTheme.titleDarkBg)
  //           )
        
  //     )
  //   ],);
    
  // }
  // Widget floatingActionBottom(model) {
  //   print('is plaaying $_isPlaying');
  //   if (_isPlaying == 'paused' || _isPlaying == 'stopped') {
  //     return FloatingActionButton(
  //       backgroundColor: Color(0xffffa500),
  //       child: Icon(Icons.play_arrow, color: Colors.white),
  //       onPressed: () {
  //         audioPlayer = new MusicFinder();
  //         widget.model.play(widget.model.allSongs[widget.model.currentTrackIndex].uri, widget.model.currentTrackIndex, widget.model.allSongs);
  //         // play(model);
  //       }
  //     );
  //   } else {
  //     return FloatingActionButton(
  //       backgroundColor: Color(0xffffa500),
  //       child: Icon(Icons.pause, color: Colors.white),
  //       onPressed: () {
  //         widget.model.pause();
  //       }
  //     );
  //   }
  // }
  // Widget projectWidget(model) {
  //   return 
  //     Flexible(
  //       child: ListView.builder(
  //         itemCount: model.allSongs.length,
  //         itemBuilder: (context, index) {
  //           final project = model.allSongs[index];
  //           // print('projects $project');
  //           return filter == null || filter == "" ?
  //           MediaItem(project, _isPlaying, index, model) : project.title.toLowerCase().contains(filter.toLowerCase()) ?

  //           MediaItem(project, _isPlaying, index, model)
  //             // return empty container if it does not contain filter
  //             : new Container(); 
  //           // return MediaItem(project, _isPlaying, index, model);
  //         },
  //       )
  //     );
}
  
// initNotification() {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//   var initializationSettingsAndroid =
//       new AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOS = new IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//       initializationSettingsAndroid, initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: onSelectNotification);
// }

// onDidReceiveLocalNotification(String payload) async {
//     print('notification received');
// }

// Future onSelectNotification(String payload) async {
//     print('notification selected');
// }

  Widget botomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
       selectedItemColor: Color(0xffff0266),
       selectedFontSize: 14.0,
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.chat_bubble_outline),
           title: Text('Online'),
         ),
        //  new BottomNavigationBarItem(
        //    icon: Icon(Icons.chat),
        //    title: Text('General Room'),
        //  ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.people),
           title: Text('All Members')
         )
       ],
     );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
     print('tapped $index');
    //  if (index == 1) {
    //     Navigator.pushNamed<bool>(
    //       context, '/general'                  
    //     );
    //  }
   });
 }

 Widget onlineMembersWidget(model) {
  return 
    Flexible(
      child: ListView.builder(
        itemCount: model.buzzMembers.length,
        itemBuilder: (context, index) {
          final project = model.buzzMembers[index];
          // print('projects $project');
          return MemberItem(project, index, model);
  
        },
      )
    );
 }

 Widget membersWidget(model) {
  return 
    Flexible(
      child: ListView.builder(
        itemCount: model.buzzMembers.length,
        itemBuilder: (context, index) {
          final project = model.buzzMembers[index];
          // print('projects $project');
          return MemberItem(project, index, model);
  
        },
      )
    );
 }
 
  Widget floatingActionButton(model) {
    return FloatingActionButton(
        backgroundColor: Color(0xffff0266),
        child: Icon(Icons.chat, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed<bool>(
            context, '/general'                  
          );
        }
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      Widget onlineMembers() {
        return Container(
          child: Column(children: <Widget>[
            Container(                           
              child: membersWidget(model)
            )
          ],)           
        );  
      // return Center(child: Text('hi, ${widget.model.authenticatedUser.firstName}', style: KontactTheme.titleDarkBg));
      }
      Widget allMembers() {
        return Container(
          child: Column(children: <Widget>[
            Container(                           
              child: membersWidget(model)
            )
          ],)           
        );  
      // return Center(child: Text('hi, ${widget.model.authenticatedUser.firstName}', style: KontactTheme.titleDarkBg));
      }

      // Widget chats() {
      //   return Center(child: Text('All converation', style: KontactTheme.titleDarkBg));
      // }

    final List<Widget> _children = [
      // chats(),
      onlineMembers(),
      allMembers(),
    ];
    return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: bodyTheming(),
      child: Scaffold(
        drawer: SideDrawer(model),
        drawerScrimColor: Colors.transparent,
        appBar: AppBar( 
          centerTitle: true,
          // All Songs
          backgroundColor: Colors.transparent,        
          title: Text('BuzzMee',
            style: KontactTheme.headline
          ) ,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context, '/'                  
                );
              },
            ),
          ],
          ),
          // tabview
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton:floatingActionButton(model),
          bottomNavigationBar: botomNavBar(),
        backgroundColor: Colors.transparent,
        body: _children[_currentIndex], 
      )
    );
    });
  }
}

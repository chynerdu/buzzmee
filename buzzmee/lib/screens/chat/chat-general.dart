import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:adonis_websok/io.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../scoped-models/main.dart';
import '../../theme-data.dart';

class ChatGeneral extends StatefulWidget {
  final MainModel model;
  ChatGeneral(this.model);
  
  State<StatefulWidget> createState() {
    return _ChatGeneral();
  }
}

class _ChatGeneral extends State<ChatGeneral> with WidgetsBindingObserver {
  Function bodyTheming = flexPlayThemeDarkBoxDecoration;
  var _controller = TextEditingController();
  ScrollController _chatcontroller = ScrollController();
  final Map<String, dynamic> _formData = {
  'message': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
   void initState() {
      widget.model.defaultWebSocket();
     WidgetsBinding.instance.addObserver(this);
     _chatcontroller.addListener(() {
       double maxScroll = _chatcontroller.position.maxScrollExtent;
       double currentScroll = _chatcontroller.position.pixels;
       double loadMorePosition = 200;
      //  print('max scroll $maxScroll');
      //  print('position $currentScroll');
       if (maxScroll - currentScroll <= loadMorePosition) {
          widget.model.getMessages(true);
       }
     });
    // adonisWebsocketConnection();
    // WidgetsBinding.instance
    //       .addPostFrameCallback((_) {
    //             Timer(Duration(milliseconds: 2000), () => _chatcontroller.jumpTo(0.0));
    //         });
    
    widget.model.getMessages(false);
    // initSocketConnection();
    // webSocketChannel();
    widget.model.incoming.listen((dynamic incoming) {
      print('incoming message $incoming');
    //    setState(() {  
         
    //     // if (updateAvailable) {
    //     //     // print('update available');
    //     //     WidgetsBinding.instance
    //     //   .addPostFrameCallback((_) => _showUpdateAlert(widget.model.appMetaData.appVersion));
             
    //     // }
    //  });
      // setState(() {  
      //    print('update availabel $updateAvailable');
      // });
     });
    super.initState();
   }

   @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      widget.model.resetCurrentPage();
      super.dispose();
    }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  print('state $state');
  if(state == AppLifecycleState.inactive){
    widget.model.updateAppState('inactive');
  } else if (state == AppLifecycleState.paused) {
    widget.model.updateAppState('paused');
  } else {
    widget.model.updateAppState('resumed');
  }
}
  webSocketChannel() async {
    var channel = IOWebSocketChannel.connect("ws://192.168.1.100:3337");
    print('socket connected  $channel');
    channel.sink.add("connected!");
     channel.stream.listen((message) {
       print('socket received  $channel');
    // ...
  });
  }
  initSocketConnection() async {
  // websocket
    final socket = IOAdonisWebsok(host: '192.168.1.100', port: 3337)
      ..withJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU4MTg0ODg0OH0.f1d4l8Ty80BURDEw_KJTpRK-U95AxqA_kRow_Mifl0s');
    // Connect to the socket and await for response from the adonis server.
    print('connecting to socket');
    await socket.connect();
    print('connected to socket');
    // Subscribe to the 'disponible' topic.
    final disponible = await socket.subscribe('room:chat');
    // Set a callback to execute when a new event comes by.
    print('connected to channel $disponible');
    // disponible.emit('canvi', 'I just joined'); 
    
      setState(() {
        disponible.on('canvi', (data) {
        print('canvi: ${data.toString()}');
      });
    });
    // To stop the listener, just perform disponible.off('canvi')
    // Emit send a new message to the server, with additional data if needed.
    disponible.emit('canvi', 'I just joined agained'); // Accepts a data argument as the 2nd parameter.
    // Close the subscription (unsubscribe from the given topic).
    final closed = await disponible.close(); // Unsubscribe.
    // CLoses the socket connection.
    // socket.close();
  }
  Widget buildtextFormField() {
    return Form(
      key: _formKey,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFB),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(13.0),
            bottomLeft: Radius.circular(13.0),
            topLeft: Radius.circular(13.0),
            topRight: Radius.circular(13.0),
          ),
        ),
      child: Row(children: <Widget>[
        Expanded( 
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              controller: _controller,
              style: TextStyle(
                color: Colors.black54,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Enter message here...',
                labelStyle: TextStyle(fontSize: 15,
                color: Colors.black54)
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter message';
                }
              },
              onSaved: (String value) {
                _formData['message'] = value;
              },
            )
          ))
      ])
      )
    );
  }
  void sendMessage(Function sendMessage) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    sendMessage(_formData['message'])
    .then((response) {
        print('sucess ${response['success']}');
      if (response['success'] == true) {
        setState(() {
          _controller.clear();
        });
      }
    });
  }

  Widget buildChatForm(model) {
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width * 0.75,
        child:  buildtextFormField(),
        ),     
        IconButton(
          icon: Icon(Icons.send, color: Colors.white),
          onPressed: () {
            sendMessage(model.sendMessage);
            // Navigator.pushNamed<bool>(
            //   context, '/login'                  
            // );
          },
        )
    ],)
    );
  }


 Widget messagesWidget(model) {
  return 
    Flexible(
      child: Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      padding: EdgeInsets.only(bottom: 60),
      child: ListView.builder(
        controller: _chatcontroller,
        reverse: true,
        shrinkWrap: true,
        itemCount: model.buzzMessages.length,
        itemBuilder: (context, index) {
          final project = model.buzzMessages[index];
          // print('projects $project');
          // if (project.id != 1) {
            return Container(
              padding: EdgeInsets.only(bottom: 40),
              child: project.senderId.toString() == widget.model.authenticatedUser.id.toString() ?
              Align(
                alignment: Alignment(0.9, -0.9),
                child: buildSenderConversationBody('${project.body}')
              ) :  Align(
                alignment: Alignment.topLeft,
                child: buildReceiverConversationBody('${project.body}', '${project.username}')
              )
            );
          // } else {
          //   return Container(
          //     padding: EdgeInsets.only(bottom: 40),
          //     child: Align(
          //       alignment: Alignment.topLeft,
          //       child: buildReceiverConversationBody('${project.body}')
          //     )
          //   );
          // }
          // return MemberItem(project, index, model);
  
        },
      ))
    );
 }
  Widget buildReceiverConversationBody(message, sender) {
    return Column(
      // direction: Direction.
      children: [
        // Expanded(
          Row(children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundColor:Color(0xffff0266),
              backgroundImage: AssetImage('assets/user-icon-3.png')
            ,),
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    borderOnForeground : true,
                    elevation: 10,
                    // margin: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left:10.0, right: 10.0, top:10.0),
                        child: Text('~$sender', style: KontactTheme.captionDark), 
                      ),
                      Container(
                        padding: EdgeInsets.only(left:10.0, right: 10.0, bottom:10.0, top:2.0),
                        child: Text('$message'), 
                      )
                    ],)
                    
                  )
                ]
              )
            ),
          ],)
        // )
      ]
    );
  }

   Widget buildSenderConversationBody(message) {
    return Column(
      // direction: Direction.
      children: [
        // Expanded(
          Row(children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Card(
                    color: Color(0xffdf6797),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    borderOnForeground : true,
                    elevation: 10,
                    // margin: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(message, style: TextStyle(color: Colors.white)), 
                    )
                  )
                ]
              )
            ),
            CircleAvatar(
              radius: 15.0,
              backgroundColor:Color(0xffff0266),
              backgroundImage: AssetImage('assets/avatar.jpg')
            ,),
          ],)
        // )
      ]
    );
  }
  Widget buildChatContainer(model) {
    return Container(
     padding: EdgeInsets.all(20.0),
     child: Stack(
      //  mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
       Column(children: <Widget>[
         messagesWidget(model)
        // Container(
        //   padding: EdgeInsets.only(bottom: 40),
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: buildReceiverConversationBody('Hello There')
        //   )
        // ),
    
      // Container(
      //   padding: EdgeInsets.only(bottom: 40),
      //   child: Align(
      //     alignment: Alignment(0.9, -0.9),
      //     child: buildSenderConversationBody('Its good to have you onboard')
      //   )
      // ),
      // Container(
      //   padding: EdgeInsets.only(bottom: 40),
      //   child: Align(
      //     alignment: Alignment(0.9, -0.9),
      //     child: buildSenderConversationBody('I would like to now better, whats your name and where are you from?')
      //   )
      // ),
      // Container(
      //   padding: EdgeInsets.only(bottom: 40),
      //   child: Align(
      //     alignment: Alignment.topLeft,
      //     child: buildReceiverConversationBody('Its a long one though')
      //   )
      // ),

        // Container(
        // padding: EdgeInsets.only(bottom: 40),
        // child: Align(
        //   alignment: Alignment(-0.9, -0.9),
        //   child: Text('hello', style: KontactTheme.headline), 
        // )
        // ),
       ],),
      Align(
        alignment: Alignment.bottomCenter,
        child: buildChatForm(model)
      )
    ],)
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: bodyTheming(),
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        appBar: AppBar( 
          centerTitle: true,
          // All Songs
          backgroundColor: Colors.transparent,        
          title: Text('General Chat Room',
            style: KontactTheme.headline
          ) ,
          actions: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundColor:Color(0xffff0266),
              backgroundImage: AssetImage('assets/avatar.jpg')
            ,)
          ],
          ),
          // tabview
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        body: buildChatContainer(model) 
      )
    );
    });
  }
}
import 'dart:io';

import 'package:adonis_websok/topic_subscription.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:adonis_websok/io.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
// import 'package:socket_io_client/socket_io_client.dart';
import 'package:websocket_manager/websocket_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'dart:convert';
import 'dart:async';

// models
import '../models/user-models.dart';
import '../models/members-models.dart';
import '../models/messages-models.dart';


mixin ConnectedModel on Model {
  bool _isLoading = false;
  UserModel _authenticatedUser;
  MembersModel _allMembers;
  List <MembersModel> _buzzMembers = [];
    List <MembersModel> _buzzOnlineMembers = []; 
  MessagesModel _allMessages;
  MessagesModel _incomingMessage;
  List <MessagesModel> _buzzMessages = [];
  String appState = 'resumed';
  String appUrl ='http://10.1.1.87:3337';
  // String appUrl = 'http://buzzmee-api.herokuapp.com';
  int currentPage = 1;
  IOWebSocketChannel socketConnection;
  Socket iOSockeet;
  TopicSubscription adonisSocket;
  PublishSubject<bool> _userSubject = PublishSubject();
  PublishSubject<dynamic> _incoming = PublishSubject();

  bool get isLoading {
    return _isLoading;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  PublishSubject<dynamic> get incoming {
    return _incoming;
  }
 UserModel get authenticatedUser {
   return _authenticatedUser;
 }

 List <MembersModel> get buzzMembers {
   return List.from(_buzzMembers);
 }

  List <MembersModel> get buzzOnlineMembers {
   return List.from(_buzzOnlineMembers);
 }

List <MessagesModel> get buzzMessages {
   return List.from(_buzzMessages);
 }
  
  Future <Map<String, dynamic>>login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();
    final authData = {
      'phone_number': phone,
      'password' : password,
    };
    http.Response response =  await http.post(
      // 'https://jsonplaceholder.typicode.com/posts'
      '$appUrl/login',
      body: authData,
      // headers: {'Content-Type': 'application/json'}
    );
    print('login response ${response.body}');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String message;
    if (responseData.containsKey('token')) {
    _authenticatedUser = UserModel(
        id: responseData["data"]["id"],
        firstName: responseData["data"]["first_name"],
        lastName: responseData["data"]["last_name"],
        phone: responseData["data"]["phone"],
        username: responseData["data"]["username"],
      );
      print('authenticated user $_authenticatedUser');
      _isLoading = false;
      notifyListeners();
      return {'success' : true, 'message': 'Login successful'};
    } else {
      message = responseData['message'];
      _isLoading = false;
      notifyListeners();
      return {'success' : false, 'message': message};
    }
  }

  Future <Map<String, dynamic>> register(String phone, String password, String first_name, String last_name, String username) async {
    _isLoading = true;
    notifyListeners();
    final authData = {
      'phone_number': phone,
      'password' : password,
      'first_name': first_name,
      'last_name': last_name,
      'username': username
    };
    print('auth data $authData');
    http.Response response =  await http.post(
      // 'https://jsonplaceholder.typicode.com/posts'
      '$appUrl/register',
      body: authData,
      // headers: {'Content-Type': 'application/json'}
    );
    print('login response ${response.body}');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String message;
    if (responseData.containsKey('token')) {
     login(phone, password);
    _authenticatedUser = UserModel(
        id: responseData["data"]["id"],
        firstName: responseData["data"]["first_name"],
        lastName: responseData["data"]["last_name"],
        phone: responseData["data"]["phone"],
        username: responseData["data"]["username"],
      );
       print('authenticated user $_authenticatedUser');
      _isLoading = false;
      notifyListeners();
      return {'success' : true, 'message': 'Login successful'};
    } else {
      message = responseData['message'];
      _isLoading = false;
      notifyListeners();
      return {'success' : false, 'message': message};
    }
  }


  void logout() async {
    print('logout');
  
   }


   Future <Map<String, dynamic>>getMembers(type) async {
     print('type $type');
    _isLoading = true;
    notifyListeners();
    http.Response response =  await http.get(
      '$appUrl/$type', 
      // headers: {'Content-Type': 'application/json'}
    );
    final responseData = jsonDecode(response.body);
    print('converted members $responseData');
    final List <MembersModel> allMembers = [];
    final  List <dynamic> dataMap = responseData["data"];
    if (type == 'allMembers') {
      dataMap.forEach((dynamic members) {
      var newMembers = MembersModel.fromJson(members);
      _allMembers = MembersModel(
          id: newMembers.id,
          firstName: newMembers.firstName,
          lastName: newMembers.lastName,
          phone: newMembers.phone,
          username: newMembers.username
        );

        allMembers.insert(0, _allMembers);
      });
      _buzzMembers = allMembers;
    } else {
      dataMap.forEach((dynamic members) {
      var newMembers = MembersModel.fromJson(members);
      _allMembers = MembersModel(
          id: newMembers.id,
          firstName: newMembers.firstName,
          lastName: newMembers.lastName,
          phone: newMembers.phone,
          username: newMembers.username
        );

        allMembers.insert(0, _allMembers);
      });
      _buzzOnlineMembers = allMembers;
    }
     _isLoading = false;
    notifyListeners();
    return null;
   }

  Future <Map<String, dynamic>>getMessages(bool fetchPrevious) async {
    _isLoading = true;
    notifyListeners();
     String url = '$appUrl/getMessages?page=1';
    if (fetchPrevious == true) {
      url = '$appUrl/getMessages?page=$currentPage';
    }
    
    http.Response response =  await http.get(
      url, 
      // headers: {'Content-Type': 'application/json'}
    );
    // print('messages response ${response.body}');
    final responseData = jsonDecode(response.body);
    // check if responseData is not empty and increase currentPage
    if (responseData.length > 1) {
      currentPage++;
      print('current page increased to $currentPage');
    }
    // print('converted message $responseData');
    final List <MessagesModel> allMessages = [];
    final  List <dynamic> messageMap = responseData["data"];
    messageMap.forEach((dynamic members) {
     var newMessageBody = MessagesModel.fromJson(members);
     _allMessages = MessagesModel(
        id: newMessageBody.id,
        senderId: newMessageBody.senderId,
        username: newMessageBody.username,
        body: newMessageBody.body,
      );
      allMessages.add(_allMessages);
    });
    if (fetchPrevious == true) {
      print('buzz messages already full');
      _buzzMessages.addAll(allMessages);
      notifyListeners();
      return null;
    }
    _buzzMessages = allMessages;
     _isLoading = false;
    notifyListeners();
    return null;
   }
  
 defaultWebSocket() async {
  // websocket
    final socket = IOAdonisWebsok(host:'10.1.1.87', port: 3337);
      // ..withJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU4MTg0ODg0OH0.f1d4l8Ty80BURDEw_KJTpRK-U95AxqA_kRow_Mifl0s');
    // Connect to the socket and await for response from the adonis server.
    print('connecting to socket');
    await socket.connect();
    print('connected to socket');
    // Subscribe to the 'disponible' topic.
    final disponible = await socket.subscribe('room:chat');
    // disponible.emit('message', 'I just joined agained');
    // Set a callback to execute when a new event comes by.
    print('connected to channel $disponible');
   adonisSocket = disponible;
    // disponible.emit('message', 'I just joined'); 
    //  _incoming.add('ready message2');
    // disponible.on('message', (data) {
    //   //  _incoming.add(data);
    //   print('canvi: $data');
    //   // notifyListeners();
    // });
    adonisSocket.on('receiveMessage', (data) {
    print('incoming data $data');
    print('authenticated ${_authenticatedUser.id.toString()}');
    //  final convertedData = jsonDecode(data);
    //  print('lenght ${data.length}');
      _incomingMessage = MessagesModel(
      id: null,
      senderId: data['sender_id'],
      username: data['username'],
      body: data['body'],
    );
    print('done');
    // final _oldBuzzMessages =  _buzzMessages;
    _buzzMessages.insert(0, _incomingMessage);
    notifyListeners();
    print('app state now $appState');
    if (appState != 'resumed') {
      displayNotification(data['username'], data['body']);
    }
    // print('new buzz ${_oldBuzzMessages[4].body}');
    notifyListeners();
    return;
    });
    // _buzzMessages = _oldBuzzMessages;
    // notifyListeners();
    // return;

    // disponible.on('error', (data) {
    //   print('error encounted');
    // });
    // To stop the listener, just perform disponible.off('canvi')
    // Emit send a new message to the server, with additional data if needed.
    // disponible.emit('canvi', 'I just joined agained'); // Accepts a data argument as the 2nd parameter.
    // Close the subscription (unsubscribe from the given topic).
    // final closed = await disponible.close(); // Unsubscribe.
    // CLoses the socket connection.
    // socket.close();
  }
  // adharaSocket() async {
  //   SocketIOManager manager = SocketIOManager();
  //   SocketIO socket = await manager.createInstance(SocketOptions('http://buzzmee-api.herokuapp.com/'));  
  //   // iOSockeet = socket;     //TODO change the port  accordingly
  //   socket.onConnect((data){
  //     print("connected...");
  //     print(data);
  //     socket.emit("message", ["Hello world!"]);
  //   });
  //   socket.on("news", (data){   //sample event
  //     print("new message $data");
  //     print(data);
  //   });
  //   socket.on("intervalMessage", (data){   //sample event
  //     print("interval message $data");
  //   });
  //   iOSockeet.on('receiveMessage', (data) {
  //     print('incoming data $data');
  //      _incomingMessage = MessagesModel(
  //       id: null,
  //       senderId: data['sender_id'],
  //       username: data['username'],
  //       body: data['body'],
  //     );
  //     // final _oldBuzzMessages =  _buzzMessages;
  //     _buzzMessages.insert(0, _incomingMessage);
  //     print('app state now $appState');
  //     if (appState != 'resumed') {
  //       displayNotification(data['username'], data['body']);
  //     }
  //     // print('new buzz ${_oldBuzzMessages[4].body}');
  //     notifyListeners();
  //     return;
  //     // _buzzMessages = _oldBuzzMessages;
  //     // notifyListeners();
  //     return;

  //   });
  //   socket.connect();
  // }
  // initSocketConnection() {
  //   // Dart client
  //   Socket socket = io('https://buzzmee-api.herokuapp.com/', <String, dynamic>{
  //     'transports': ['websocket'],
  //     'upgrade': false,// optional
  //   });
  //   iOSockeet = socket;
  //   // IO.Socket socket = IO.io('$appUrl');
  //   // socket.emit('msg', 'test2');
  //   socket.on('connect', (_) {
  //     socket.emit('msg', 'test');
  //   });
  //   // socket.on('server', (_) {
  //   //   socket.emit('msg', 'hello');
  //   // });
  //   socket.on('receiveMessage', (data) {
  //     print('incoming data $data');
  //      _incomingMessage = MessagesModel(
  //       id: null,
  //       senderId: data['sender_id'],
  //       username: data['username'],
  //       body: data['body'],
  //     );
  //     // final _oldBuzzMessages =  _buzzMessages;
  //     _buzzMessages.insert(0, _incomingMessage);
  //     // print('new buzz ${_oldBuzzMessages[4].body}');
  //     if (appState != 'resumed') {
  //       displayNotification(data['username'], data['body']);
  //     }
  //     notifyListeners();
  //     // _buzzMessages = _oldBuzzMessages;
  //     // notifyListeners();
  //     return;

  //   });
    
    
  //   socket.on('event', (data) => print('event received $data'));
  //   socket.on('disconnect', (_) => print('disconnect'));
  //   socket.on('fromServer', (_) => print(_));
  // }
  
  displayNotification(sender, body) async {
    // initNotification();
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      sender,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  initNotification() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
}

onDidReceiveLocalNotification(String payload) async {
    print('notification received');
}

Future onSelectNotification(String payload) async {
    print('notification selected');
}
  
  Future <Map<String, dynamic>> sendMessage(dynamic body) async {
     print('message data $body');
     print('message id ${_authenticatedUser.id}');
    _isLoading = true;
    // notifyListeners();
    final Map<String, dynamic> messageData = {
      'sender_id': _authenticatedUser.id.toString(),
      'body': body
    };
    http.Response response =  await http.post(
      '$appUrl/sendMessage',
      body: messageData,
    );

    print('message response ${response.body}');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String message;  
      message = responseData['message'];
      _isLoading = false;
      final broadcastMessageData = {
        'body': body,
        'sender_id': _authenticatedUser.id,
        'username':  _authenticatedUser.username,
      };

      if (adonisSocket != null) {
        adonisSocket.emit('sendMessage', broadcastMessageData);
      }
      //  socketConnection.sink.add(body);
      return {'success' : true, 'message': 'Message sent'};
  }

  resetCurrentPage() {
    print('reseting current page');
    currentPage = 1;
  }

  updateAppState(updateState) {
    print('app state $updateState');
    appState = updateState;
  }

}
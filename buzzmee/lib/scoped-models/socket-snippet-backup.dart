 // defaultSocket() async {
    // with http
  // HttpClient client = HttpClient(/* optional security context here */);
  // HttpClientRequest request = await client.get('10.1.1.87', 3337,
  //     '/foo/ws?api_key=myapikey'); // form the correct url here
  // request.headers.add('Connection', 'upgrade');
  // request.headers.add('Upgrade', 'websocket');
  // request.headers.add('sec-websocket-version', '13'); // insert the correct version here
  // // request.headers.add('sec-websocket-key', key);
  //   HttpClientResponse response = await request.close();
  //    Socket channel = await response.detachSocket();

  //   WebSocket ws = WebSocket.fromUpgradedSocket(
  //   channel,
  //   serverSide: false,
  // );



  //   Map myheaders=new Map<String,dynamic>();
  //   myheaders["Origin"]="file://";
  //   myheaders["Connection"] = "Upgrade";
  //   myheaders["Upgrade"] = "Sebsocket";
  //   myheaders["Content-Length"] = 0;
  //   myheaders["Sec-websocket-protocol"]="xmpp";
  //    myheaders["Sec-websocket-version"]="13";
  //   var channel = IOWebSocketChannel.connect("ws://10.1.1.87:3337/adonis-ws");
  //   print('socket connected  $channel');
  //     channel.sink.add("connected to IOWebsocket");
  //     channel.stream.listen((message) {
  //       print('socket received  $channel');
  //       print('message $message');
  //       socketConnection = channel;
  //     // ...
  //   });
  // }
  // void sendBroadCastmessage() async {
  // // websocket
  //   final socket = IOAdonisWebsok(host: '10.1.1.87', port: 3337)
  //     ..withJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU4MTg0ODg0OH0.f1d4l8Ty80BURDEw_KJTpRK-U95AxqA_kRow_Mifl0s');
  //   // Connect to the socket and await for response from the adonis server.
  //   // print('connecting to socket');
  //   await socket.connect();
  //   // print('connected to socket');
  //   print('socket subscription $socket');
  //   // Subscribe to the 'disponible' topic.
  //   final disponible = await socket.subscribe('room:chat');
  //   // disponible.emit('message', 'I just joined agained');
  //   // Set a callback to execute when a new event comes by.
  //   // print('connected to channel $disponible');
  //   // disponible.emit('message', 'I just joined'); 
  //   //  _incoming.add('ready message');
  //   disponible.on('message', (data) {
  //      _incoming.add(data);
  //     print('canvi: $data');
  //     // notifyListeners();
  //   });

  //   // disponible.on('error', (data) {
  //   //   print('error encounted');
  //   // });
  //   // To stop the listener, just perform disponible.off('canvi')
  //   // Emit send a new message to the server, with additional data if needed.
  //   disponible.emit('canvi', 'I just joined agained'); // Accepts a data argument as the 2nd parameter.
  //   // Close the subscription (unsubscribe from the given topic).
  //   // final closed = await disponible.close(); // Unsubscribe.
  //   // CLoses the socket connection.
  //   // socket.close();
  // }

  // void initSocketConnection() {
  //   const oneSec = const Duration(seconds: 20);
  //   new Timer.periodic(oneSec, (t) {
  //     // print('running after one second $t');
  //     sendBroadCastmessage();
  //   });
  // }
  // void newSocketConnection() async {
  // // websocket
  //   final socket = IOAdonisWebsok(host: '10.1.1.87', port: 3337);
  //     // ..withJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU4MTg0ODg0OH0.f1d4l8Ty80BURDEw_KJTpRK-U95AxqA_kRow_Mifl0s');
  //   // Connect to the socket and await for response from the adonis server.
  //   print('connecting to socket');
  //   await socket.connect();
  //   print('connected to socket');
  //   // Subscribe to the 'disponible' topic.
  //   final disponible = await socket.subscribe('room:chat');
  //   // disponible.emit('message', 'I just joined agained');
  //   // Set a callback to execute when a new event comes by.
  //   print('connected to channel $disponible');
  //   disponible.emit('message', 'I just joined'); 
  //   //  _incoming.add('ready message');
  //   disponible.on('message', (data) {
  //      _incoming.add(data);
  //     print('canvi: $data');
  //     notifyListeners();
  //   });

  //   // disponible.on('error', (data) {
  //   //   print('error encounted');
  //   // });
  //   // To stop the listener, just perform disponible.off('canvi')
  //   // Emit send a new message to the server, with additional data if needed.
  //   disponible.emit('canvi', 'I just joined agained'); // Accepts a data argument as the 2nd parameter.
  //   // Close the subscription (unsubscribe from the given topic).
  //   // final closed = await disponible.close(); // Unsubscribe.
  //   // CLoses the socket connection.
  //   // socket.close();
  // }
  
  // defaultSocket2() {
  //   int messageNum = 0;
  //   // Configure WebSocket url
  //   final socket = WebsocketManager('ws://10.1.1.87:3337');
  //   // Listen to close message
  //   socket.onClose((dynamic message) {
  //       print('close');
  //   });
  //    socket.send('hello just joined');
  //   // Listen to server messages
  //   socket.onMessage((dynamic message) {
  //       print('recv: $message');
  //       if (messageNum == 10) {
  //           socket.close();
  //       } else {
  //           messageNum += 1;
  //           final String msg = '$messageNum: ${DateTime.now()}';
  //           print('send: $msg');
  //           socket.send(msg);
  //       }
  //   });
  //   // Connect to server
  //   socket.connect();
  // }

  // defaultWebSocket() async{
  //   Map myheaders=new Map<String,dynamic>();
  //   myheaders["Origin"]="*";
  //   myheaders["Connection"] = "Upgrade";
  //   myheaders["Upgrade"] = "Sebsocket";
  //   myheaders["Content-Length"] = 0;
  //   myheaders["Sec-websocket-protocol"]="http";
  //    myheaders["Sec-websocket-version"]="13";
  //   var channel = IOWebSocketChannel.connect("ws://10.1.1.88:3337/websocket", headers: myheaders);
  //   print('socket connected  $channel');
  //     channel.sink.add("connected to IOWebsocket");
  //     channel.stream.listen((message) {
  //       print('socket received  $channel');
  //       print('message $message');
  //       socketConnection = channel;
  //     // ...
  //   });
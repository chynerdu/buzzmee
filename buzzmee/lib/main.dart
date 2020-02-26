import 'package:flutter/material.dart';
import 'package:adonis_websok/io.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

// screens
import './screens/auth/login.dart';
import './screens/auth/register.dart';
import './screens/home/home.dart';
import './screens/chat/chat-general.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Workmanager.initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  // Workmanager.registerOneOffTask("1", "simpleTask");
  Workmanager.registerPeriodicTask(
    "2", 
    "simplePeriodicTask", 
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    // frequency: Duration(hours: 1),
);
  await initNotification();
  
  // initNotification();
  // Create a websocket connection and attach a JWT to it.
  // For HTML: IOAdonisWebsok -> HTMLAdonisWebsok
  // websocket
  // final socket = IOAdonisWebsok(host: '10.1.1.91', port: 3337)
  //   ..withJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU4MTYwODg0N30.m6jsl21PVi0KR0S04zVHzAbcBz3sr72b7q3-aK_maEo');
  // // Connect to the socket and await for response from the adonis server.
  // print('connecting to socket');
  // await socket.connect();
  // print('connected to socket');
  // // Subscribe to the 'disponible' topic.
  // final disponible = await socket.subscribe('room:public');
  // // Set a callback to execute when a new event comes by.
  // print('connected to channel');
  // disponible.on('canvi', (data) => print('canvi: ${data.toString()}'));
  // // To stop the listener, just perform disponible.off('canvi')
  // // Emit send a new message to the server, with additional data if needed.
  // disponible.emit('canvi'); // Accepts a data argument as the 2nd parameter.
  // // Close the subscription (unsubscribe from the given topic).
  // final closed = await disponible.close(); // Unsubscribe.
  // // CLoses the socket connection.
  // socket.close();

runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    print("Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}
initNotification() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('conversation');
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
class MyApp extends StatelessWidget {
  final MainModel _model = MainModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
    model: _model,
    child: OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BuzzMee',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Colors.black
        ),
        routes: {
          '/': (BuildContext context) => Auth(),
           '/register': (BuildContext context) => Register(),
          '/home': (BuildContext context) => Home(_model),
          // '/listing': (BuildContext context) => ContactList(),
          // '/media': (BuildContext context) => ExampleMedia(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[1] == 'general') {
          return MaterialPageRoute<bool> (
            builder:(BuildContext context) => ChatGeneral(_model)
          );
        } 
        // else if (pathElements[1] == 'new-playlist') {
        //   return MaterialPageRoute<bool> (
        //     builder:(BuildContext context) => NewPlaylistForm()
        //   );
        // } 
        },
        // home: MyHomePage(title: 'BuzzMee'),
      )
    )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

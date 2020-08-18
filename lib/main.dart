import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trello/app/utils/todo.dart';
import 'package:flutter_trello/provider/homepage.dart';
import 'package:provider/provider.dart';

import 'app/pages/trello/trello_Screen.dart';
import 'app/pages/try/offline_try.dart';
import 'app/pages/try/try_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
//    deleteCompleteTask();
  }

  void deleteCompleteTask() {
    Firestore.instance
        .collection(Todo().features["completed"])
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
        Timestamp timestamp = documentSnapshot.data["date"];
        String date = timestamp.toDate().year.toString() +
            timestamp.toDate().month.toString() +
            timestamp.toDate().day.toString();

        if (date !=
            "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}") {
          Firestore.instance
              .collection(Todo().features["completed"])
              .document(documentSnapshot.documentID)
              .delete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // * screen preferred scale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TrelloScreen(),
    );
  }
}
//MultiProvider(providers: [ChangeNotifierProvider(create: (context) => TrelloScreenProvider(),)], child: OfflineTry())

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_trello/app/services/offline_services.dart';
import 'package:flutter_trello/app/services/online_services.dart';
import 'package:flutter_trello/app/utils/todo.dart';
import 'package:flutter_trello/data/repositries/repository.dart';

// * exporting widgets
import '../../widgets/export_widgets.dart';

class TrelloScreen extends StatefulWidget {
  @override
  _TrelloScreenState createState() => _TrelloScreenState();
}

class _TrelloScreenState extends State<TrelloScreen> {
  Firestore firestore = Firestore();

  PageController pageController;
  List<Container> todoList;

  List<DocumentSnapshot> thingsTodoList;
  List<DocumentSnapshot> doingList;
  List<DocumentSnapshot> doneList;

  String collectionName;
  String todoName;
  Timestamp timeDate;

  @override
  void initState() {
    super.initState();
    fetchThingsToDo();
    fetchDoing();
    fetchDone();
    oflineFetch();
  }

  oflineFetch(){
    SqDatabase()..fetch(tabelName: SqDatabase.thingstodo).then((value) => print(value.length));
  }

  fetchDone() {
    doneList = [];
    Services(collectionName: Todo().features["completed"])
      ..fetchCompletedTask("date").listen((QuerySnapshot snapshot) {
        print("CRUD tryL: ${snapshot.documents.length}");

        setState(() {
          doneList.clear();
        });

        snapshot.documents.forEach(
              (DocumentSnapshot documentSnapshot) {
            // * ARRAY START
            setState(() {
              doneList.add(documentSnapshot);
            });
            // * END
          },
        );

        if (snapshot.documents.length == 0) {
          setState(() {
            doneList.clear();
          });
        }
      });
  }

  fetchDoing() {
    doingList = [];
    Services(collectionName: Todo().features["inprocess"])
      ..fetchCompletedTask("date").listen((QuerySnapshot snapshot) {
        setState(() {
          doingList.clear();
        });
        snapshot.documents.forEach(
              (DocumentSnapshot documentSnapshot) {
            // * ARRAY START
            setState(() {
              doingList.add(documentSnapshot);
            });
            // * END
          },
        );
        // !
        if (snapshot.documents.length == 0) {
          setState(() {
            doingList.clear();
          });
        }
      });
  }

  fetchThingsToDo() {
    thingsTodoList = [];
    Services(collectionName: Todo().features["todo"])
      ..fetchCompletedTask("date").listen(
            (QuerySnapshot snapshot) {
          setState(() {
            thingsTodoList.clear();
          });
          snapshot.documents.forEach(
                (DocumentSnapshot documentSnapshot) {
              // * ARRAY START
              setState(() {
                thingsTodoList.add(documentSnapshot);
              });
              // * END
            },
          );
          if (snapshot.documents.length == 0) {
            setState(() {
              thingsTodoList.clear();
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // * End Drawer 🙌
      endDrawer: SafeArea(
        child: Center(
          child: _buildDone(),
        ),
      ),
      // * End Drawer 🙌
      drawer: SafeArea(
        child: Center(
          child: BuildContainer(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // * things to do 🧿
              _buildThingTooDO(),
              _buildDoing(),
              // _buildDone(),
            ],
          ),
        ),
      ),
      //*  DONE  - target state
      bottomNavigationBar:  buildDoneDragTarget(size, collectionName),
    );
  }
  // * done state
  DragTarget<String> buildDoneDragTarget(Size size, String collectionName)  {
    return DragTarget(
      onAccept: (String value) async {
        // * accepting in process task to done task
        if (collectionName == "doing") {
          // * setting up for shifting task to different collection
          await firestore
              .collection(collectionName)
              .document(value)
              .get()
              .then((document) {
            // setState(() {
            //   timeDate = document.data["date"];
            // });

            // * shifting task in both online && offline
            Repository()..shiftingTask(task: value, dateTime: document.data["date"], tableName: Todo().features["completed"]);

            // * deleting task in both online && offline
            Repository()..deleteTask(task: value, tableName: collectionName);

            // * shifting task to different collection
            // Services(collectionName: Todo().features["completed"])
            //   ..shiftTasks(value: value, dateTime: document.data["date"]);
          });

          // * deleting task from previous collection
          // Services(collectionName: collectionName)
          //   ..deleteRecord(docName: value);
        }
        // else{
        // TODO vibrate when improcess list is dragged
        //   // await HapticFeedback.vibrate();
        // }
      },
      builder: (BuildContext context, List<dynamic> acceptedData,
          List<dynamic> rejectedData) {
        return doneTaskDragTraget(size);
      },
    );
  }

  Container _buildDone() {
    return Container(
      alignment: Alignment.topCenter,
      width: 300,
      child: Card(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildCardTitle("Done  ", doneList),
                  // * title list
                  _buildDoneList(doneList),
                ],
              ),
            ),
            cardBanner(Colors.lightGreen, Colors.green),
          ],
        ),
      ),
    );
  }

  Padding _buildDoneList(List<DocumentSnapshot> list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: list.length > 0
          ? ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // String data = doneList[index].data["task"];
          return doneTaskCard(index, list);
        },
      )
          : Text("No Data"),
    );
  }

  // * in process state
  Container _buildDoing() {
    return Container(
      alignment: Alignment.topCenter,
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildCardTitle("In progress  ", doingList),
                  // * title list
                  _buildDoingDragTraget()
                ],
              ),
            ),
            cardBanner(Colors.orangeAccent, Colors.orange),
          ],
        ),
      ),
    );
  }

  DragTarget<String> _buildDoingDragTraget() {
    return DragTarget(
      onAccept: (String value) async {
        if (collectionName != Todo().features["inprocess"]) {
          print(value);

          await firestore
              .collection(collectionName)
              .document(value)
              .get()
              .then((document) {
            // setState(() {
            //   timeDate = document.data["date"];
            // });

            // * shifting task in both online && offline
            Repository()..shiftingTask(task: value, dateTime: document.data["date"], tableName: Todo().features["inprocess"]);

            // * deleting task in both online && offline
            Repository()..deleteTask(task: value, tableName: collectionName);

            // * shifting task doing collection
            // Services(collectionName: Todo().features["inprocess"])
            //   ..shiftTasks(value: value, dateTime: document.data["date"]);
          });

          // * deleting task
          // Services(collectionName: collectionName)
          //   ..deleteRecord(docName: value);
        }
      },
      builder: (BuildContext context, List<dynamic> accecptedData,
          List<dynamic> rejectedData) {
        return inProcessList(doingList);
      },
    );
  }

  Padding inProcessList(List<DocumentSnapshot> doingList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: doingList.length > 0
          ? ListView.builder(
        shrinkWrap: true,
        itemCount: doingList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String data = doingList[index].data["task"];
          return _buildDoingDragable(data, index);
        },
      )
          : Container(
        decoration:
        BoxDecoration(border: Border.all(color: Colors.blueGrey)),
        padding: EdgeInsets.all(10),
        child: Text(
          "+ Drag List here",
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
    );
  }

  Draggable<String> _buildDoingDragable(String data, int index) {
    return LongPressDraggable<String>(
      onDragStarted: () {
        print("doing");
        setState(() {
          collectionName = Todo().features["inprocess"];
        });
      },
      data: data,
      child: taskCard(index, doingList),
      feedback: Container(
        width: 300,
        padding: EdgeInsets.all(8),
        child: taskCard(index, doingList),
      ),
      childWhenDragging: Card(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(doingList[index].data["task"]),
        ),
      ),
    );
  }

// * things to do card START
// * To-do state
  Container _buildThingTooDO() {
    return Container(
      alignment: Alignment.topCenter,
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
            )),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildCardTitle("Todo  ", thingsTodoList),
                  // * title list
                  _buildThingsTODODragTraget(
                      collectionName, thingsTodoList, doingList),
                ],
              ),
            ),
            cardBanner(Colors.redAccent, Colors.red.shade700),
          ],
        ),
      ),
    );
  }

  DragTarget<String> _buildThingsTODODragTraget(String collectionName,
      List<DocumentSnapshot> thingsTodoList, List<DocumentSnapshot> doingList) {
    return DragTarget(
      onAccept: (String value) async {
        if (collectionName != Todo().features["todo"]) {
          print(value);

          await firestore
              .collection(collectionName)
              .document(value)
              .get()
              .then((document) {
            // setState(() {
            //   timeDate = document.data["date"];
            // });

            // * shifting task in both online && offline
            Repository()..shiftingTask(task: value, dateTime: document.data["date"], tableName: Todo().features["todo"]);

            // * deleting task in both online && offline
            Repository()..deleteTask(task: value, tableName: collectionName);

            // * shifting task thingstodo collection
            // Services(collectionName: Todo().features["todo"])
            //   ..shiftTasks(value: value, dateTime: document.data["date"]);
          });

          // * deleting task
          // Services(collectionName: collectionName)
          //   ..deleteRecord(docName: value);
        }
      },
      builder: (BuildContext context, List<dynamic> accecptedData,
          List<dynamic> rejectedData) {
        return thingstodoList(thingsTodoList, doingList);
      },
    );
  }

  Padding thingstodoList(
      List<DocumentSnapshot> thingsTodoList, List<DocumentSnapshot> doingList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: thingsTodoList.length > 0
          ? ListView.builder(
        shrinkWrap: true,
        itemCount: thingsTodoList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String data = thingsTodoList[index].data["task"];
          return _buildThingsTODODragable(data, index);
        },
      )
          : Container(
        decoration:
        BoxDecoration(border: Border.all(color: Colors.blueGrey)),
        padding: EdgeInsets.all(10),
        child: Text(
          doingList.length > 0 // * if in process list is empty 😍
              ? "+ Drag List here"
              : "Empty Todo List",
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
    );
  }

  Draggable<String> _buildThingsTODODragable(String data, int index) {
    return LongPressDraggable<String>(
      onDragStarted: () {
        setState(() {
          collectionName = Todo().features["todo"];
        });
      },
      data: data,
      child: taskCard(index, thingsTodoList),
      feedback: Container(
        width: 300,
        padding: EdgeInsets.all(8),
        child: taskCard(index, thingsTodoList),
      ),
      childWhenDragging: Card(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(thingsTodoList[index].data["task"]),
        ),
      ),
    );
  }
// * things to do card END
}
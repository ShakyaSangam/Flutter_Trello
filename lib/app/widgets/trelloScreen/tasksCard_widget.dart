import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trello/app/services/online_services.dart';
import 'package:flutter_trello/app/utils/todo.dart';
import 'package:flutter_trello/data/repositries/repository.dart';

Positioned cardBanner(Color firstColor, Color secondColor, [double width]) {
  return Positioned(
    top: 0.0,
    child: Column(
      children: [
        Container(
          width: width ?? 300,
          height: 8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
              colors: <Color>[firstColor, secondColor],
            ),
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
            ),
          ),
        ),
      ],
    ),
  );
}

Container buildCardTitle(String title, List<DocumentSnapshot> list) {
  return Container(
    width: 300,
    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)),
          child: Text(list.length.toString(),
              style: TextStyle(color: Colors.grey.shade600)),
        ),
      ],
    ),
  );
}

Card taskCard(int index, List<DocumentSnapshot> list) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(list[index].data["task"]),
    ),
  );
}

Card doneTaskCard(int index, List<DocumentSnapshot> list) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(list[index].data["task"]),
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {

            // * shifting to different collection
            Repository()..shiftTaskRecord(task: list[index].data["task"], dateTime: DateTime.now().millisecondsSinceEpoch, tableName: value);

            // * shifting to different collection
            // Services(collectionName: value)
            //   ..addRecord(docName: list[index].data["task"], dateTime: DateTime.now().millisecondsSinceEpoch);

            // * delete from done collection
            Repository()..deleteTask(task: list[index].data["task"], tableName: Todo().features["completed"]);

            // * delete from done collection
            // Services(collectionName: Todo().features["completed"])
            //   ..deleteRecord(docName: list[index].data["task"]);
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: Todo().features["todo"],
                child: Text("Todo"),
              ),
              PopupMenuItem(
                value: Todo().features["inprocess"],
                child: Text("In Process"),
              ),
            ];
          },
        ),
      ],
    ),
  );
}

Container doneTaskDragTraget(Size size) {
  return Container(
    width: size.width,
    height: 62,
    decoration: BoxDecoration(color: Colors.blueGrey.shade100),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Swipe"),
                  Icon(Icons.keyboard_arrow_right, color: Colors.blueGrey),
                ],
              ),
              Text(
                "Add Todo",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.blueGrey),
              Text(
                "Drag list here",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_left, color: Colors.blueGrey),
                  Text("Swipe"),
                ],
              ),
              Text(
                "Done List",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

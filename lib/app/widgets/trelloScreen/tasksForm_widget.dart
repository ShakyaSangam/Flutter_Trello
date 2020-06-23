import 'package:flutter/material.dart';
import 'package:flutter_trello/app/services/online_crud.dart';
import 'package:flutter_trello/app/utils/todo.dart';

import 'tasksCard_widget.dart';

Container buildContainer(Size size, String todoName) {
  return Container(
    alignment: Alignment.topCenter,
    width: size.width - 100,
    child: SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0))),
        child: ListTile(
          title: TextField(
            textInputAction: TextInputAction.done,
            onChanged: (String value) {
              todoName = value;
            },
            decoration:
                InputDecoration(hintText: "Add list", labelText: "List Name"),
          ),
          subtitle: MaterialButton(
            onPressed: () {
              if (todoName.isNotEmpty) {
                // * creating new task
                Services(collectionName: Todo().features["todo"])
                  ..addRecord(docName: todoName);
              }
            },
            child: Text("Add"),
          ),
        ),
      ),
    ),
  );
}

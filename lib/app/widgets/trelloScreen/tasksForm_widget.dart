import 'package:flutter/material.dart';
// import 'package:flutter_trello/app/services/online_services.dart';
// import 'package:flutter_trello/app/utils/todo.dart';
import '../../../data/repositries/repository.dart';

class BuildContainer extends StatefulWidget {
  @override
  _BuildContainerState createState() => _BuildContainerState();
}

class _BuildContainerState extends State<BuildContainer> {
  TextEditingController controller = TextEditingController();
  String todoName;

  Container buildContainer(Size size) {
    return Container(
      alignment: Alignment.topCenter,
      width: size.width - 100,
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0))),
          child: ListTile(
            title: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onChanged: (String value) {
                // * IS NOT USED
                todoName = value; // ! if error occours replace controller with todoName variable [String]
              },
              decoration:
                  InputDecoration(hintText: "Add list", labelText: "List Name"),
            ),
            subtitle: MaterialButton(
              onPressed: () {
                print(controller.text);
                if (controller.text == "") {
                  print(todoName);
                } else {
                  print(controller.text);
                  Repository()
                    ..taskInitialize(
                            task: controller.text,
                            dateTime: DateTime.now().millisecondsSinceEpoch)
                        .then((value) => print("Task completed"));
                }

                // if (!todoName.isEmpty) {
                // print(todoName);
                //   // * creating new task
                //   // Services(collectionName: Todo().features["todo"])
                //   //   ..addRecord(docName: todoName);
                // Repository()..taskInitialize(task: controller.text, dateTime: DateTime.now().millisecondsSinceEpoch).then((value) => print("Task completed"));
                // }
              },
              child: Text("Add"),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildContainer(size,);
  }
}
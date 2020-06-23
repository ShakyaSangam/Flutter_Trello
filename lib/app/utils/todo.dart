import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {

  Map<String, String> features = {
    "todo": "thingstodo",
    "inprocess": "doing",
    "completed": "done"
  };

  Map<String, dynamic> shiftingData(String value, Timestamp dateTime) {
    return {
      "task": value,
      "date": dateTime,
    };
  }

  Map<String, dynamic> addingData(String value) {
    return {
      "task": value,
      "date": DateTime.now()
    };
  }
}

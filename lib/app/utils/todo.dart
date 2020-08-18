class Todo {

  Map<String, String> features = {
    "todo": "thingstodo",
    "inprocess": "doing",
    "completed": "done"
  };

  Map<String, dynamic> shiftingData(String value, int dateTime) {
    return {
      "task": value,
      "date": dateTime,
    };
  }

  // ! optional datetime of millisecond is initialized
  Map<String, dynamic> addingData(String value, int dateTime) {
    return {
      "task": value,
      "date": dateTime
    };
  }
}

import 'package:flutter_trello/app/utils/todo.dart';

import '../../app/services/offline_services.dart';
import '../../app/services/online_services.dart';

class Repository{
  // TODO implement online && offline service 
  /**
   * * it gonna take time
   */

  SqDatabase sqDatabase = SqDatabase(); // * offline services


  // * task initialize to user  
  Future taskInitialize ({String task, int dateTime}) async{
    
    print("offline service working fine");
    return await sqDatabase.initData(task: task, datetime: dateTime, tableName: Todo().features["todo"]).then((value) {

      print("online service working fine");
      Services(collectionName: Todo().features["todo"])..addRecord(docName: task, dateTime: dateTime);
    });
  }

  // * changing assign-task state 
  Future shiftingTask({String task, int dateTime, String tableName}) async{
    print("offline service working fine");
    return await sqDatabase.shiftData(task: task, dateTime: dateTime, tableName: tableName).then((value) {
      
      // * deleting previous record from online db.
      print("online service working fine");
      Services(collectionName: tableName).shiftTasks(value: task, dateTime: dateTime);

    });
  }

  Future deleteTask({String task, String tableName}) async{
    print("offline service working fine");
    return await sqDatabase.deleteRecord(task, tableName).then((value) {
      // * deleting previous record from online db.
      Services(collectionName: tableName)..deleteRecord(docName: task);
    });
  }

  Future shiftTaskRecord({String task, int dateTime, String tableName}) async{

    // * shift task
    //  offline service 
    print("offline service working fine");
    return await sqDatabase.initData(task: task, datetime: dateTime, tableName: tableName).then((value) {
      
      print("online service working fine");
      Services(collectionName: tableName)..addRecord(docName: task, dateTime: dateTime).then((value) => print("Record shifted"));
    });
  }

  // TODO deleting assign-task froom todo state
}
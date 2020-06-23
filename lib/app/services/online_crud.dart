import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/todo.dart';

class Services {
  Todo todo = Todo();

  String collectionName;
  CollectionReference collectionReference;

  Services({this.collectionName}) {
    collectionReference = Firestore.instance.collection(collectionName);
  }

  // * adding new task with new dateTime
  Future<void> addRecord({String docName}) async {
    return await collectionReference
        .document(docName)
        .setData(todo.addingData(docName));
  }

  //* adding previous task && previous dateTime
  Future<void> shiftTasks({String value, Timestamp dateTime}) {
    return collectionReference
        .document(value)
        .setData(todo.shiftingData(value, dateTime));
  }

  //  * read
  Future<DocumentSnapshot> fetchSingleDoc({String docsName}) async {
    return await collectionReference.document(docsName).get();
  }

  // * deleting task
  Future<void> deleteRecord({String docName}) async {
    return await collectionReference.document(docName).delete();
  }

  // * fetch completed task [Done] order by date😍
  Stream<QuerySnapshot> fetchCompletedTask([String orderBy = "date"]) {
    return collectionReference.orderBy(orderBy).snapshots();
  }
}
